class EsukhiaClient
  ORG_NAME = 'esukhia'.freeze
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
    resources = @octokit_client.contents('Esukhia/Corpora', path: "Parallel/84000", ref: "872aada11a14ab1ce0b0255df514882f040bda2b")
  rescue StandardError => e
    raise Exceptions::RemoteError.new("Octokit Error", e)
  end
end