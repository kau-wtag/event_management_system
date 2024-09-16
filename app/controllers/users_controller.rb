class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:index]

  def index
    @users = User.all
  end

  def show
    @registrations = @user.registrations
    @favorites = @user.favorites.includes(:event) # Preload events to avoid N+1 query
    @likes = @user.likes.includes(:event) # Preload events to avoid N+1 query
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t('users.messages.created') # I18n message for user creation success
      redirect_to root_path
    else
      flash.now[:alert] = t('users.messages.error') # I18n message for error
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t('users.messages.updated') # I18n message for user update success
      redirect_to @user
    else
      flash.now[:alert] = t('users.messages.error') # I18n message for error
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session
    flash[:notice] = t('users.messages.deleted') # I18n message for user deletion success
    redirect_to root_path, status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
