class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show refresh_index]

  require_power_check

  power crud: :collections, as: :collection_scope

  def index
    grid_attributes = params.fetch(:collections_grid, {}).merge(current_power: current_power)
    @collections_grid = CollectionsGrid.new(params[:page], grid_attributes)
  end

  def show
    render layout: false
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.fetch(:collection, {})
  end
end
