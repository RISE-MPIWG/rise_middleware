module Admin
  module Collections
    class ResourcesController < ApplicationController
      before_action :set_collection, only: %i[index new create edit update destroy refresh_index pull_full_text show]
      before_action :set_resource, only: %i[destroy pull_full_text content_as_tree show]

      def index
        grid_attributes = params.fetch(:admin_collections_resources_grid, {}).merge(current_power: current_power, collection: @collection)
        @resources_grid = Admin::Collections::ResourcesGrid.new(params[:page], grid_attributes)
      end

      # pulls index of resources from mapped API endpoint
      def refresh_index
        attributes = {}
        attributes[:collection_id] = @collection.id
        attributes[:user_id] = current_user.id
        RefreshCollectionResourcesJob.perform_later(attributes)
        # to perform directly (without worker) uncomment below and comment above
        # @collection.refresh_index(user_id: current_user.id)
        redirect_to [:admin, @collection, Resource], notice: 'Resource Index Update Job Successfully Started'
      end

      def pull_full_text
        # TODO should in theory always be possible for admin user, but still needs some logic
        @resource.pull_full_text(current_user)
        respond_to do |format|
          format.js {}
        end
      end

      def show
        render 'resources/show'
      end

      def new
        @resource = Resource.new
      end

      def edit; end

      def create
        @resource = Resource.new(resource_params)
        @resource.collection = @collection
        @resource.created_by_id = current_user.id
        if @resource.save
          redirect_to [:admin, @collection, Resource], notice: 'Resource was successfully created.'
        else
          render :new
        end
      end

      def update
        if @resource.update(resource_params)
          redirect_to @resource, notice: 'Resource was successfully updated.'
        else
          render [@collection, Resource]
        end
      end

      def destroy
        @resource.destroy
        @resource.save
        redirect_to [:admin, @collection, Resource], notice: 'Resource was successfully deleted.'
      end

      def request_access
        user_resource = UserResource.find_or_create_by(user_id: current_user.id, resource_id: @resource.id)
        user_resource.access_right = :requested
        user_resource.save
        # TODO Send a notification mail to the owner of the resource
        redirect_to resources_url, notice: 'You have successfully requested acccess to this resource - the administator of this resource has been notified and will treat your case as soon as possible.'
      end

      private

      def set_resource
        @resource = Resource.find(params[:id])
      end

      def set_collection
        @collection = Collection.find(params[:collection_id])
      end

      def resource_params
        params.fetch(:resource, {}).permit(:name, :uri)
      end
    end
  end
end
