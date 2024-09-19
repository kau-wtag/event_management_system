class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :set_user, only: [:show]
  before_action :require_signin
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    # @user is already set by the set_user method
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
