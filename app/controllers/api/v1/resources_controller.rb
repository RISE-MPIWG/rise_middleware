module Api
  module V1
    class ResourcesController < Api::ApiController
      before_action :set_resource, only: %i{show metadata}
      before_action :set_headers, only: :show

      require_power_check
      power crud: :resources, as: :resource_scope

      def index
        @resources = current_power.readable_resources
        @resources = @resources.where("resources.name ilike '%#{params[:filter]}%'") if params[:filter]
        @resources = @resources.where("resources.metadata -> 'dublincore' ->> :key ILIKE :value", key: "creator", value: "%#{params[:creator_filter].strip}%") if params[:creator_filter]
        @resources = @resources.where("resources.metadata -> 'dublincore' ->> :key ILIKE :value", key: "language", value: "%#{params[:language_filter].strip}%") if params[:language_filter]

        @resources = @resources.where("resources.metadata::text ILIKE '%#{params[:metadata_filter].strip}%'") if params[:metadata_filter]
        respond_to do |format|
          format.html { paginate json: @resources.page(params[:page])}
          format.json { paginate json: @resources.page(params[:page])}
          format.xml { render xml: ResourcesRenderer.xml(@resources.page(params[:page]))}
        end

      end

      def show
        unless current_power.readable_resource?(@resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        if @resource.sections.empty?
          @resource.pull_sections(current_user)
        end
        # different render options
        respond_to do |format|
          format.html { render json: @resource, serializer: ResourceWithSectionsSerializer}
          format.json { render json: @resource, serializer: ResourceWithSectionsSerializer }
          format.xml  { render xml: ResourceRenderer.xml(@resource) }
        end
      end

      def metadata
        unless current_power.readable_resource?(@resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        render json: @resource.cascading_metadata.to_json
      end

      private
      
      def set_headers
        response.headers['Accept'] = ['application/json', 'application/xml']
      end

      def render_errors
        render json: { errors: @resource.errors }, status: :unprocessable_entity
      end

      def set_resource
        @resource = Resource.from_uuid(params[:uuid])
      end

      def resource_params
        params.require(:resource).permit(:filter)
      end
    end
  end
end
