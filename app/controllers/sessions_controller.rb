class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.email_verified
        session[:user_id] = user.id
        if user.admin?
          redirect_to admin_dashboard_index_url, notice: "Welcome back, #{user.name}!"
        else
          redirect_to (session[:intended_url] || user), notice: "Welcome back, #{user.name}!"
          session[:intended_url] = nil
        end
      else
        flash[:alert] = "Please verify your email before logging in."
        redirect_to new_session_path
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, status: :see_other, notice: "You've been signed out!"
  end
end
