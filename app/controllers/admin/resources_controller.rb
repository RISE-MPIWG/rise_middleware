module Admin
  class ResourcesController < ApplicationController
    before_action :set_resource, only: %i[show edit update request_access destroy]

    require_power_check

    power crud: :resources, as: :resource_scope

    def index
      grid_attributes = params.fetch(:admin_resources_grid, {}).merge(current_power: current_power)
      @resources_grid = Admin::ResourcesGrid.new(params[:page], grid_attributes)
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
      @resource.created_by_id = current_user.id
      if @resource.save
        redirect_to [:admin, Resource], notice: 'Resource was successfully created.'
      else
        render :new
      end
    end

    def update
      if @resource.update(resource_params)
        redirect_to [:admin, @resource], notice: 'Resource was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @resource.archive
      redirect_to admin_resources_url, notice: 'Resource was successfully archived.'
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

    def resource_params
      params.fetch(:resource, {}).permit(:name, :uri)
    end
  end
end
