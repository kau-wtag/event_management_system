class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      if user.email_verified
        session[:user_id] = user.id
        
        if user.admin?
          redirect_to admin_dashboard_index_url, notice: t('sessions.create.welcome_back_admin', name: user.name)
        elsif user.organizer?
          redirect_to organizer_dashboard_index_url, notice: t('sessions.create.welcome_back_organizer', name: user.name)
          session[:intended_url] = nil
        else
          redirect_to (session[:intended_url] || user), notice: t('sessions.create.welcome_back_user', name: user.name)
          session[:intended_url] = nil
        end
      else
        flash[:alert] = t('sessions.create.email_not_verified')
        redirect_to new_session_path
      end
    else
      flash.now[:alert] = t('sessions.create.invalid_credentials')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, status: :see_other, notice: t('sessions.destroy.signed_out')
  end
end
 