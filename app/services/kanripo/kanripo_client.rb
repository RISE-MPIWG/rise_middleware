class KanripoClient
  ORG_NAME = 'kanripo'.freeze
  # REPO_NAMES_TO_AVOID = ["Catalog files for Kanseki Repository 各種漢籍目録", "metadata for automatic consumption by textref.org", "Not-encoded characters in KR files.", "Template for user workspace"].freeze
  REPO_NAMES_TO_AVOID = ['KR-Gaiji', 'KR-Workspace', 'KR-Catalog', 'textrefmetadata', 'iiif'].freeze
  attr_reader :octokit_client

  def initialize(_params = {})
    stack = Faraday::RackBuilder.new do |builder|
      builder.use Octokit::Response::RaiseError
      builder.use Octokit::Middleware::FollowRedirects
      builder.use Octokit::Response::RaiseError
      builder.use Octokit::Response::FeedParser
      builder.response :logger
      builder.use Faraday::HttpCache, serializer: Marshal, store: Rails.cache
      builder.adapter Faraday.default_adapter
    end

    Octokit.middleware = stack

    @octokit_client = Octokit::Client.new(
      access_token: ENV['GITHUB_ACCESS_TOKEN'],
      auto_traversal: true,
      auto_paginate: true
    )
  end

  def fetch_resources
    resources = @octokit_client.organization_repositories(ORG_NAME, per_page: 100)
    resources.delete_if { |x| REPO_NAMES_TO_AVOID.include? x.name }
  rescue StandardError => e
    raise Exceptions::RemoteError.new("Octokit Error", e)
  end

  def fetch_readme(resource)
    @octokit_client.contents(resource.metadata['dublincore']['title']).select { |content| File.basename(content.name) == "Readme.org" }.first.download_url
  end
end
