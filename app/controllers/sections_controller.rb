class SectionsController < ApplicationController
  before_action :set_section, only: %i[show]

  require_power_check

  power crud: :resources, as: :resource_scope

  def show
    unless current_power.readable_resource?(@section.resource)
      render json: { error: 'you do not have access to the resource this section belongs to' }, status: :unauthorized
      return
    end
    @content_units = @section.pull_content_units(current_user)
    # @section.reload
    # @content_units = @section.content_units.page(params[:page])
    # render json: @content_units
    render json: Kaminari.paginate_array(@content_units).page(params[:page]).per(10)
  end

  private

  def set_section
    @section = Section.find_by(id: params[:id])
  end
end
