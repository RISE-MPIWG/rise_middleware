module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy refresh_api_token]

    require_power_check

    power crud: :users, as: :user_scope

    def index
      grid_attributes = params.fetch(:admin_users_grid, {}).merge(current_power: current_power)
      @users_grid = Admin::UsersGrid.new(params[:page], grid_attributes)
    end

    def show
      render layout: false
    end

    def new
      @user = User.new
    end

    def refresh_api_token
      current_user.generate_auth_token
      redirect_to edit_user_registration_path(@user)
    end

    def edit; end

    def create
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to [:edit, :admin, @user], notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @user.archive
      redirect_to [:admin, User], notice: 'User was successfully archived.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.fetch(:user, {}).permit(:email, :role)
    end
  end
end
