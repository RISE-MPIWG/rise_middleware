module Admin
  class ResearchToolsController < ApplicationController
    include Consul::Controller
    include Logging

    before_action :set_research_tool, only: %i[show edit update request_access destroy manage_access download_api_definition_file api_definition update_api_definition_file]

    require_power_check

    power crud: :research_tools, as: :research_tool_scope

    def index
      grid_attributes = params.fetch(:admin_research_tools_grid, {}).merge(current_power: current_power)
      @research_tools_grid = Admin::ResearchToolsGrid.new(params[:page], grid_attributes)
    end

    def show; end

    def new
      @research_tool = ResearchTool.new
    end

    def edit; end

    def create
      @research_tool = ResearchTool.new(research_tool_params)
      @research_tool.created_by = current_user
      if @research_tool.save
        redirect_to [:admin, ResearchTool], notice: 'Research Tool was successfully created.'
      else
        render :new
      end
    end

    def manage_access
      grid_attributes = params.fetch(:admin_research_tools_organisations_grid, {}).merge(current_power: current_power, research_tool: @research_tool)
      @organisations_grid = Admin::ResearchTools::OrganisationsGrid.new(params[:page], grid_attributes)
    end

    def api_definition; end

    def update
      if @research_tool.update(research_tool_params)
        redirect_to [:edit, :admin, @research_tool], notice: 'Research Tool was successfully updated.'
      else
        render :edit
      end
    end

    # TODO dry this out a little bit
    def update_api_definition_file
      if @research_tool.update(research_tool_params)
        redirect_to [:api_definition, :admin, @research_tool], notice: 'Research Tool was successfully updated.'
      else
        render :api_definition
      end
    end

    def destroy
      @research_tool.archive
      redirect_to admin_research_tools_url, notice: 'Research Tool was successfully archived.'
    end

    def download_api_definition_file
      send_file(
        @research_tool.api_definition_file.path,
        filename: "#{@research_tool.slug}_api_definition.yaml",
        type: @research_tool.api_definition_file.content_type,
        disposition: :attachment,
        url_based_filename: true
      )
    end

    private

    def set_research_tool
      @research_tool = ResearchTool.find(params[:id])
    end

    def research_tool_params
      params.fetch(:research_tool, {}).permit(:name, :slug, :description, :url)
    end
  end
end
