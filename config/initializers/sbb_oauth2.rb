SBB_OAUTH2_CLIENT = OAuth2c::Client.new(
  authz_url:     ENV['SBB_OAUTH_AUTH_URL'],
  token_url:     ENV['SBB_OAUTH_TOKEN_URL'],
  client_id:     ENV['SBB_CLIENT_ID'],
  client_secret: ENV['SBB_CLIENT_SECRET'],
  redirect_uri:  ENV['SBB_OAUTH_REDIRECT_URL']
)
