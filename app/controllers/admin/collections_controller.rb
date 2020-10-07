module Admin
  class CollectionsController < ApplicationController
    before_action :set_collection, only: %i[show edit update request_access destroy manage_organisation_access manage_research_tool_access download_api_definition_file api_definition update_api_definition_file mapping]

    require_power_check

    power crud: :collections, as: :collection_scope

    def index
      grid_attributes = params.fetch(:admin_collections_grid, {}).merge(current_power: current_power)
      @collections_grid = Admin::CollectionsGrid.new(params[:page], grid_attributes)
    end

    def show; end

    def new
      @collection = Collection.new
    end

    def refresh_all_indexes
      attributes = {}
      attributes[:user_id] = current_user.id
      RefreshAllCollectionResourcesJob.perform_later(attributes)
      # to perform directly (without worker) uncomment below and comment above
      # @collection.refresh_index(user_id: current_user.id)
      redirect_to [:admin, Collection], notice: 'Resource Indexes Update Job Successfully Started'
    end

    def edit; end

    def create
      @collection = Collection.new(collection_params)
      @collection.organisation_id = current_user.organisation_id
      @collection.created_by = current_user
      if @collection.save
        redirect_to [:admin, Collection], notice: 'Collection was successfully created.'
      else
        render :new
      end
    end

    def manage_organisation_access
      grid_attributes = params.fetch(:admin_collections_organisations_grid, {}).merge(current_power: current_power, collection: @collection)
      @organisations_grid = Admin::Collections::OrganisationsGrid.new(params[:page], grid_attributes)
    end

    def manage_research_tool_access
      grid_attributes = params.fetch(:admin_collections_research_tools_grid, {}).merge(current_power: current_power, collection: @collection)
      @research_tools_grid = Admin::Collections::ResearchToolsGrid.new(params[:page], grid_attributes)
    end

    def update
      if @collection.update(collection_params)
        redirect_to [:edit, :admin, @collection], notice: 'Collection was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @collection.archive
      redirect_to admin_collections_url, notice: 'Collection was successfully archived.'
    end

    private

    def set_collection
      @collection = Collection.find(params[:id])
    end

    def collection_params
      params.fetch(:collection, {}).permit(:name, :slug, :api_url, :original_uuid, :access_type, :api_mapping_module)
    end
  end
end
