module Admin
  class UserLogsController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy refresh_api_token]

    require_power_check

    power crud: :user_logs, as: :user_log_scope

    def index
      grid_attributes = params.fetch(:admin_user_logs_grid, {}).merge(current_power: current_power)
      @user_logs_grid = Admin::UserLogsGrid.new(params[:page], grid_attributes)
    end
  end
end
