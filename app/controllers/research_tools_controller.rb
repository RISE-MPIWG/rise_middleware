class ResearchToolsController < ApplicationController
  before_action :set_research_tool, only: [:show]

  require_power_check

  power crud: :collections, as: :collection_scope

  def index
    grid_attributes = params.fetch(:research_tools_grid, {}).merge(current_power: current_power)
    @research_tools_grid = ResearchToolsGrid.new(params[:page], grid_attributes)
  end

  def show
    render layout: false
  end

  private

  def set_research_tool
    @research_tool = ResearchTool.find(params[:id])
  end

  def research_tool_params
    params.fetch(:research_tool, {})
  end
end
