require 'utilities'
class StandardClient
  include Utilities
  attr_reader :api_url, :headers, :params

  def initialize(api_url, api_token = nil)
    @api_url = api_url
    @headers = {}
    @headers['User-Agent'] = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10"
    @headers['Content-Type'] = 'application/json'
    @headers['RISE-API-TOKEN'] = api_token if api_token
    @params = {}
    # make sure we get all results in one page...
    @params[:page] = 1
    @params[:per_page] = 600_000
  end

  def fetch_collections
    fetch_response('/collections')
  end

  def fetch_resources(resources_path)
    fetch_response(resources_path)
  end

  def fetch_sections(resource_uuid)
    fetch_response("resources/#{resource_uuid}/sections")
  end

  def fetch_content_units(section_uuid)
    fetch_response("sections/#{section_uuid}/content_units")
  end

  def fetch_resource_metadata(uuid)
    fetch_response("resources/#{uuid}/metadata")
  end

  def fetch_section_metadata(_uuid)
    fetch_response
  end

  def fetch_content_unit_metadata(uuid)
    fetch_response("content_units/#{uuid}/metadata")
  end

  def fetch_collections_metadata_parallel(urls = [], _path = '')
    hydra = Typhoeus::Hydra.hydra
    requests = urls.map { |collection|
      request = Typhoeus::Request.new(collection[:api_url] + "/collections/#{collection[:original_uuid]}" + '/metadata', followlocation: true, ssl_verifypeer: false, headers: @headers)
      hydra.queue(request)
      [collection, request]
    }

    hydra.run
    requests.map { |x|
      if valid_json?(x[1].response.body) && x[1].response.response_code == 200
        x[0].merge(metadata: JSON.parse(x[1].response.body))
      else
        x[0]
      end
    }
  end

  def fetch_resources_metadata_parallel(urls = [], _path = '')
    hydra = Typhoeus::Hydra.new(max_concurrency: 2)
    requests = urls.map { |resource|
      request = Typhoeus::Request.new(resource[:uri] + '/metadata', followlocation: true, ssl_verifypeer: false, headers: @headers)
      hydra.queue(request)
      [resource, request]
    }

    hydra.run
    requests.map { |x|
      if valid_json?(x[1].response.body) && x[1].response.response_code == 200
        x[0].merge(metadata: JSON.parse(x[1].response.body))
      else
        x[0]
      end
    }
  end

  def fetch_paginated_response(path)
    Enumerator.new do |yielder|
      @params[:page] = 1
      @params[:per_page] = 600_000
      loop do
        results = fetch_response(path)
        if results.is_a?(Array) && !results.empty?
          results.map { |item| yielder << item }
          @params[:page] += 1
        else
          raise StopIteration
        end
      end
    end.lazy
  end

  private

  def fetch_response(path)
    request = Typhoeus::Request.new(@api_url + '/' + path, followlocation: true, ssl_verifypeer: false, headers: @headers, params: @params)
    request.on_complete do |response|
      return handle_response(response)
    end
    request.run
  end

  def handle_response(response)
    code = response.response_code
    case code
    when 200
      JSON.parse response.response_body
    when 401
      raise Exceptions::RemoteError.new("Remote Error: Unauthorized", code)
    when 404
      raise Exceptions::RemoteError.new("Remote Error: Not Found", code)
    when 500
      raise Exceptions::RemoteError.new("Remote Error: Internal Server Error", code)
    when 503
      raise Exceptions::RemoteError.new("Remote Error: Service Unavailable", code)
    when 504
      raise Exceptions::RemoteError.new("Remote Error: Timeout", code)
    else
      raise Exceptions::RemoteError.new("Remote Error: Unknown", code)
    end
  end
end
