class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :delete_avatar]
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy, :delete_avatar]
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
      flash[:notice] = "Please check your email to verify your account."
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to root_path, status: :see_other, notice: 'User was successfully deleted.'
  end

  def delete_avatar
    @user.avatar.purge
    redirect_to edit_user_path(@user), notice: 'Avatar was successfully deleted.'
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
