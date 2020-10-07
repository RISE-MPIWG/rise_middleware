class Oauth2Client
  def initialize(params = {})
    @params = params
  end

  def client
    OAuth2c::Client.new(
      authz_url:     "https://imd.staatsbibliothek-berlin.de:8443/imd/oauth/authorize",
      token_url:     "https://imd.staatsbibliothek-berlin.de:8443/imd/oauth/token",
      client_id:     "rise",
      client_secret: "sdfoi2/cx3$%",
      redirect_uri:  "http://localhost:4000/oauth_callback",
    )
  end

  def perform_grant
    profile = OAuth2c::Grants::Assertion::JWTProfile.new(
      "HS512",
      "assertion-key",
      iss: "https://imd.staatsbibliothek-berlin.de:8843/imd",
      aud: "https://authorization-server.example",
      sub: "user@example.com",
    )
    grant = OAUTH2C_CLIENT.assertion(profile: profile, scope: ["profile", "email"])
    grant.token
  end
end
