require 'faraday'
require 'faraday_middleware'

class DtsClient
  def initialize(organisation)
    @organisation = organisation
    @faraday_client = Faraday.new(url: @organisation.api_url) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.response :logger
      faraday.adapter :typhoeus
      faraday.ssl[:verify] = false
      faraday.headers['Content-Type'] = 'application/ld+json'
    end
  end

  def create_index
    get_collections
    get_resources
    get_sections
  end

  def get_collections
    collections_response = fetch_response('dts/collections')
    if collections_response['totalItems'] != 1
      collections_response['member'].each do |collection|
        Collection.create!(
          name: "(#{@organisation.name}) " + collection['title'],
          organisation_id: @organisation.id,
          access_type: 'public_access',
          api_mapping_module: 'dts',
          original_uuid: collection['@id'],
          metadata: {
            description: collection['description']
          }
        )
      end
    else
      default_collection_id = collections_response['member'].first['@id']
      default_collection_response = fetch_response('dts/collections', {id: default_collection_id })
      default_collection_response['member'].each do |collection|
        Collection.create!(
          name: "(#{@organisation.name}) " + collection['title'],
          organisation_id: @organisation.id,
          access_type: 'public_access',
          api_mapping_module: 'dts',
          original_uuid: collection['@id'],
          metadata: {
            description: collection['description']
          }
        )
      end
    end
  end

  def get_resources
    @organisation.collections.each do |collection|
      resources_response = fetch_response('dts/collections', { id: collection.original_uuid })
      resources = []
      resources_response['member'].each do |resource|
        resources << {
          name: resource['title'],
          original_uuid: resource['@id'],
          collection_id: collection.id,
          uri: resource['dts:download']
        }
      end

      Resource.import resources
    end
  end

  def get_sections
    @organisation.resources.each do |resource|

      if resource.uri != nil
        Section.create(resource_id: resource.id, name: resource.name, uri: resource.uri)
      else
        sections_response = fetch_response('dts/collections', {id: resource.original_uuid})
        sections = []

        case sections_response['@type']
        when 'Resource'
          Section.create!(
            resource_id: resource.id,
            name: sections_response['title'],
            uri: sections_response['dts:download'],
            original_uuid: sections_response['@id'],
            metadata: {
              dublincore: sections_response['dts:dublincore']
            }
          )
        when 'Collection'
          sections_response['member'].each do |section|
            sections << {
              resource_id: resource.id,
              name: section['title'],
              original_uuid: section['@id']
            }
          end
          Section.import sections
        end

        check_subsections(resource.sections)
      end
    end
  end


  def check_subsections(sections)
    sections.each do |section|
      subsections_response = fetch_response('dts/collections', { id: section.original_uuid})

      case subsections_response['@type']
      when 'Resource'
        section.update_attributes!(
          metadata: {
            dts: subsections_response
          },
          original_uuid: subsections_response['@id']
        )
      when 'Collection'
        subsections_response['member'].each do |subsection|
          section.children.create!(
            name: subsection['title'],
            original_uuid: subsection['@id'],
            resource_id: section.resource.id
          )

          subsections = section.children

          check_subsections(subsections)
        end
      end
    end
  end

  def get_content_units(section)
    if section.uri != nil
      xml = download_document(section.uri)
      content_units = TeiParser.new(xml, section).parse_xml
    else
      document_response =  @faraday_client.get(@organisation.api_url + '/dts/document', { id: section.original_uuid})

      xml = document_response.body.encode!('UTF-16', 'UTF-8')
      content_units = TeiParser.new(xml, section).parse_xml
    end
  end


  def download_document(url)
    document_response = Faraday.get(url)
    xml =  document_response.body
    xml.encode!('UTF-16', 'UTF-8')
  end

  def fetch_response(path, params={})
    response = @faraday_client.get path, params
    handle_response(response)
  end

  def handle_response(response)
    code = response.status
    case code
    when 200
      JSON.parse response.body
    when 401
      raise Exceptions::RemoteError.new("Unauthorized", code)
    when 404
      raise Exceptions::RemoteError.new("Not Found", code)
    when 500
      raise Exceptions::RemoteError.new("Internal Server Error", code)
    when 503
      raise Exceptions::RemoteError.new("Service Unavailable", code)
    when 504
      raise Exceptions::RemoteError.new("Timeout", code)
    else
      raise Exceptions::RemoteError.new("Unknown", code)
    end
  end
end
