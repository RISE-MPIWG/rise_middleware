module Users
  class RegistrationsController < Devise::RegistrationsController
    def update_resource(resource, user_params)
      if user_params[:password].blank?
        user_params.delete(:password)
        user_params.delete(:password_confirmation) if params[:password_confirmation].blank?
      end
      resource.update_attributes(user_params)
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    def after_sign_up_path_for(_resource)
      resources_path
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :name, :affiliation, :position, :password_confirmation, :organisation_id)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :preferred_language, :organisation_id)
    end
  end
end
