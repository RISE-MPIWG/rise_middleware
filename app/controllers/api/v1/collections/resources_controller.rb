module Api
  module V1
    module Collections
      class ResourcesController < Api::ApiController
        before_action :set_collection, only: %i{index}

        require_power_check
        power crud: :resources, as: :resource_scope

        def index
          unless current_power.readable_collection?(@collection)
            render json: { error: 'you do not have access to this collection' }, status: :unauthorized
            return
          end
          @resources = @collection.resources
          @resources = @resources.where("resources.name ilike '%#{params[:filter]}%'") if params[:filter]
          @resources = @resources.where("resources.metadata -> 'dublincore' ->> :key ILIKE :value", key: "creator", value: "%#{params[:creator_filter].strip}%") if params[:creator_filter]
          @resources = @resources.where("resources.metadata -> 'dublincore' ->> :key ILIKE :value", key: "language", value: "%#{params[:language_filter].strip}%") if params[:language_filter]
          @resources = @resources.where("resources.metadata::text ILIKE '%#{params[:metadata_filter].strip}%'") if params[:metadata_filter]
          paginate json: @resources, each_serializer: CollectionResourceSerializer
        end

        private

        def set_collection
          @collection = Collection.from_uuid(params[:collection_uuid])
        end
      end
    end
  end
end
