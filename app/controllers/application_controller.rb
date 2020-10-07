class ApplicationController < ActionController::Base
  include Consul::Controller
  include Logging

  current_power do
    Power.new(current_user)
  end

  def handle_unverified_request; end
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = %i{email password password_confirmation preferred_language}
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  before_action :set_locale

  def set_locale
    # I18n.locale = if current_user && current_user.preferred_language.present?
    #                 current_user.preferred_language
    #               elsif I18n.available_locales.include? extract_locale_from_accept_language_header
    #                 extract_locale_from_accept_language_header
    #               else
    #                 'en'
    #               end
    # force english for the time being
    I18n.locale = 'en'
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE'].present?
  end
end
