class ToolExportsController < ApplicationController
  before_action :set_tool_export, only: %i[show download]

  require_power_check

  power crud: :collections, as: :collection_scope

  def index
    grid_attributes = params.fetch(:tool_exports_grid, {}).merge(current_power: current_power)
    @tool_exports_grid = ToolExportsGrid.new(params[:page], grid_attributes)
  end

  def new
    @tool_export = ToolExport.new
  end

  def show
    render layout: false
  end

  def create
    @tool_export = ToolExport.new(tool_export_params)
    @tool_export.user_id = current_user.id
    if @tool_export.save
      redirect_to ToolExport, notice: 'Tool Export was successfully created.'
    else
      render :new
    end
  end

  def download
    send_file(@tool_export.file.url, type: @tool_export.file.data["metadata"]["mime_type"], disposition: :attachment)
  end

  private

  def set_tool_export
    @tool_export = ToolExport.find(params[:id])
  end

  def tool_export_params
    params.fetch(:tool_export, {}).permit(:name, :notes, :file, :privacy_type)
  end
end
