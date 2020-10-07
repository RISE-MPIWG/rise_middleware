module RequestSpecHelper
  include Warden::Test::Helpers

  def get_auth_token_for(user)
    user.generate_auth_token
  end

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  def json
    JSON.parse(response.body).with_indifferent_access
  end

  def api_sign_in(resource); end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end
