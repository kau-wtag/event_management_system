class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :set_user, only: [:show, :destroy]
  before_action :require_signin
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    # @user is already set by the set_user method
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: t('admin.users.messages.deleted'), status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
