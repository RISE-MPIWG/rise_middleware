module Api
  module V1
    class RpServicesController < Api::ApiController
      def register_instance
        rp_url = request.headers['HTTP_REFERER']
        rprs = RpRegistrationService.new(rp_url, rp_params[:organisation], rp_params[:email])
        rprs.register
        render json: { message: 'registration_completed' }, status: :ok
      end

      private

      def render_errors
        render json: { errors: @resource.errors }, status: :unprocessable_entity
      end

      def rp_params
        params.permit(:organisation, :email)
      end
    end
  end
end
