class ResourcesController < ApplicationController
  before_action :set_resource, only: %i[show sections_for_tree_display edit_tags]

  require_power_check

  power crud: :resources, as: :resource_scope

  def index
    @corpus = current_user.corpora.includes(corpus_resources: :resource).first if current_user
    grid_attributes = params.fetch(:resources_grid, {}).merge(current_power: current_power, corpus: @corpus)
    @resources_grid = ResourcesGrid.new(params[:page], grid_attributes)
  end

  def edit_tags
    current_user.tag(@resource, with: resource_params[:tag_list], on: :tags)
    respond_to do |format|
      format.js {}
    end
  end

  def show; end

  def sections_for_tree_display
    return unless current_power.readable_resource?(@resource)

    if @resource.sections.empty?
      RemoteSectionsService.refresh_sections @resource, current_user
    end
    sections_as_array = BuildSectionsTreeService.tree @resource
    
    render json: sections_as_array
  end

  def content_units_for_display
    unless current_power.readable_resource?(@section.resource)
      render json: { error: 'you do not have access to the resource this section belongs to' }, status: :unauthorized
      return
    end
    @section.pull_content_units(current_user)
    @content_units = @section.content_units
    @content_units = @content_units.where("content_units.title ilike '%#{params[:filter]}%' or contents ilike '%#{params[:filter]}%'") if params[:filter]
    render json: @content_units
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end

  def resource_params
    params.fetch(:resource, {}).permit(:tag_list)
  end
end
