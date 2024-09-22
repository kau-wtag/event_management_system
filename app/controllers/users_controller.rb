class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update delete_avatar]
  before_action :require_signin, except: %i[new_organizer new_user new create_user create_organizer]
  before_action :require_correct_user, only: %i[edit update delete_avatar]
  before_action :require_admin, only: [:index] # Only apply `require_admin` to index

  layout :choose_layout

  def index
    @users = User.all
  end

  def show
    @registrations = @user.registrations
    @favorites = @user.favorites.includes(:event) # Preload events to avoid N+1 query
    @likes = @user.likes.includes(:event) # Preload events to avoid N+1 query
  end

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    @user.role = 'user'
    if @user.save
      flash[:notice] = 'Please check your email to verify your account.'
      redirect_to root_path
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def new_organizer
    @user = User.new
  end

  def create_organizer
    @user = User.new(user_params)
    @user.role = 'organizer'
    if @user.save
      flash[:notice] = 'Please check your email to verify your account.'
      redirect_to root_path
    else
      render :new_organizer, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
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

  def choose_layout
    if current_user&.admin?
      'admin'
    elsif current_user&.organizer?
      'organizer'
    else
      'application'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
