module Api
  module V1
    class CollectionsController < Api::ApiController
      # before_action :require_login!
      before_action :set_collection, only: %i{show metadata}
      before_action :set_headers, only: :show

      require_power_check
      power crud: :collections, as: :collection_scope

      def index
        @collections = current_power.readable_collections
        @collections = @collections.where("name ilike '%#{params[:filter]}%'") if params[:filter]
        @collections = @collections.where("metadata ->> :key ILIKE :value", key: "author", value: "%#{params[:author_filter].strip}%") if params[:author_filter]
        @collections = @collections.where("metadata ->> :key ILIKE :value", key: "language", value: "%#{params[:language_filter].strip}%") if params[:language_filter]

        respond_to do |format|
          format.html { paginate json: @collections }
          format.json { paginate json: @collections }
          format.xml  { render xml: CollectionsRenderer.xml(@collections) }
        end
      end

      def metadata
          render json: @collection.metadata, status: :ok
      end

      def show
        unless current_power.readable_collection?(@collection)
          render json: { error: 'you do not have access to this collection' }, status: :unauthorized
          return
        end
        respond_to do |format|
          format.html { render json: @collection }
          format.json { render json: @collection }
          format.xml  { render xml: CollectionRenderer.xml(@collection) }
        end
      end

      def metadata
        unless current_power.readable_collection?(@collection)
          render json: { error: 'you do not have access to this collection' }, status: :unauthorized
          return
        end
        respond_to do |format|
          format.html { render json: @collection.cascading_metadata }
          format.json { render json: @collection.cascading_metadata }
        end
      end


      private

      def set_headers
        response.headers['Accept'] = ['application/json', 'application/xml']
      end

      def render_errors
        render json: { errors: @collection.errors }, status: :unprocessable_entity
      end

      def set_collection
        @collection = Collection.from_uuid(params[:uuid])
      end
    end
  end
end
