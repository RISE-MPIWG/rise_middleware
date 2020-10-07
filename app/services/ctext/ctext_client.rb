class CtextClient
  BASE_URL = 'http://api.ctext.org/'.freeze
  attr_reader :faraday_client, :api_key

  def initialize(api_url, api_key = nil)
    @api_key = api_key
    @faraday_client = Faraday.new(url: api_url) do |faraday|
      faraday.response :logger
      faraday.adapter :typhoeus
      faraday.ssl[:verify] = false
      faraday.headers['Content-Type'] = 'application/json'
      faraday.params[:apikey] = api_key
    end
    @headers = {}
    @headers['Content-Type'] = 'application/json'
  end

  def fetch_resources
    fetch_response('gettexttitles')
  end

  def fetch_resource_metadata(urn)
    fetch_response("gettextinfo?urn=#{urn}")
  end

  def fetch_sections(uri)
    fetch_response("gettext?urn=#{uri}")
  end

  def fetch_subsections(uri)
    fetch_response("gettext?urn=#{uri}")
  end

  def fetch_content_units(uri)
    fetch_response("gettext?urn=#{uri}")
  end

  def fetch_section_metadata(uuid)
    fetch_response("sections/#{uuid}/metadata")
  end

  def fetch_content_unit_metadata(uuid)
    fetch_response("content_units/#{uuid}/metadata")
  end

  def fetch_metadata_parallel(urls = [], path = '')
    hydra = Typhoeus::Hydra.hydra

    requests = urls.map { |resource|
      request = Typhoeus::Request.new(BASE_URL + path + resource[:uri], params: { apikey: api_key }, followlocation: true, ssl_verifypeer: false, headers: @headers)
      hydra.queue(request)
      [resource, request]
    }

    hydra.run

    requests.map { |x|

      parsed_metadata = JSON.parse(x[1].response.body)

      edition = if (parsed_metadata['edition'] && parsed_metadata['edition']['title'])
        parsed_metadata['edition']['title']
      else
        ''
      end
      

      x[0].merge(
        metadata: {
          dublincore: {
            title: parsed_metadata['title'],
            language: 'zh-Hant',
            edition: edition

          },
          extra: parsed_metadata
        }
      )
    }
  end

  def fetch_sections_parallel(urls = [], path = '')
    hydra = Typhoeus::Hydra.hydra

    requests = urls.map { |section_uri|
      request = Typhoeus::Request.new(BASE_URL + path + section_uri, params: { apikey: api_key }, followlocation: true, ssl_verifypeer: false, headers: @headers)
      hydra.queue(request)
      [section_uri, request]
    }

    hydra.run

    requests.map { |request|
      { uri: request[0], response: JSON.parse(request[1].response.body) }
    }
  end

  private

  def fetch_response(path)
    response = faraday_client.get path
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
