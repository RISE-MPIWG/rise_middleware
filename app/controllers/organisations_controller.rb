class OrganisationsController < ApplicationController
  before_action :set_organisation, only: %i[show]

  require_power_check

  power crud: :organisations, as: :organisation_scope

  def index
    @q = organisation_scope.ransack(params[:q])
    @organisations = @q.result(distinct: true)
  end

  def show
    render layout: false
  end

  private

  def set_organisation
    @organisation = Organisation.find(params[:id])
  end

  def organisation_params
    params.fetch(:organisation, {})
  end
end
