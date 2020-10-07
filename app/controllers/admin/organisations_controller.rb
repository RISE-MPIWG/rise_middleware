module Admin
  class OrganisationsController < ApplicationController
    before_action :set_organisation, only: %i[show edit update destroy scrap_collections]

    require_power_check

    power crud: :organisations, as: :organisation_scope

    def index
      grid_attributes = params.fetch(:admin_organisations_grid, {}).merge(current_power: current_power)
      @organisations_grid = Admin::OrganisationsGrid.new(params[:page], grid_attributes)
    end

    def show; end

    def new
      @organisation = Organisation.new
    end

    def edit; end

    def create
      @organisation = Organisation.new(organisation_params)
      if @organisation.save
        redirect_to [:admin, Organisation], notice: 'Organisation was successfully created.'
      else
        render :new
      end
    end

    def scrap_collections
      rps = RemoteCollectionsService.new(@organisation.id)
      rps.refresh_collections
      redirect_to [:edit, :admin, @organisation], notice: 'Collections updated'
    end

    def update
      if @organisation.update(organisation_params)
        redirect_to [:edit, :admin, @organisation], notice: 'Organisation was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @organisation.archive
      redirect_to [:admin, Organisation], notice: 'Organisation was successfully destroyed.'
    end

    private

    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    def organisation_params
      params.fetch(:organisation, {}).permit(:name, :slug, :api_url, :api_mapping_module,:default_collection_access_type, :scrap_collections)
    end
  end
end
