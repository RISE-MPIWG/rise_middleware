class ShibboController < ApplicationController
  def index
    shibbo_data = {}
    shibbo_data[:institution_display_name] = request.headers['HTTP_MDDISPLAYNAME']
    shibbo_data[:session_id] = request.headers['HTTP_SHIB_SESSION_ID']
    shibbo_data[:session_index] = request.headers['HTTP_SHIB_SESSION_INDEX']
    shibbo_data[:identity_provider] = request.headers['HTTP_SHIB_IDENTITY_PROVIDER']
    shibbo_data[:cookie_name] = request.headers['HTTP_SHIB_COOKIE_NAME']
    shibbo_data[:authentication_method] = request.headers['HTTP_SHIB_AUTHENTICATION_METHOD']
    shibbo_data[:eppn] = request.headers['HTTP_EPPN']
    shibbo_data[:handles] = request.headers['HTTP_SHIB_HANDLER']
    user = User.from_shibboleth(shibbo_data)
    if user
      sign_in(:user, user)
      redirect_to '/', notice: 'signed in successfully'
    else
      redirect_to '/', notice: 'we could not sign you in, please check if shibbo is ok'
    end
  end

  def show
    render layout: false
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.fetch(:collection, {})
  end
end
