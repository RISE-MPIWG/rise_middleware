class PagesController < ApplicationController
  require_power_check
  power crud: :resources, as: :resource_scope

  def index
    grid_attributes = params.fetch(:resources_grid, {}).merge(current_power: current_power)
    @resources_grid = ResourcesGrid.new(params[:page], grid_attributes)
  end

  def search; end

  def about; end

  def community; end

  def rise; end

  def tools; end

  def imprint; end
  
end
