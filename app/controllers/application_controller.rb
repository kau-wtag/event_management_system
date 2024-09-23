class ApplicationController < ActionController::Base
  before_action :set_locale

  # Make current_user accessible to views
  helper_method :current_user, :current_user?

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_layout
    return 'admin' if current_user&.admin?
    return 'organizer' if current_user&.organizer?

    'application' # Default layout for users
  end

  # Fetch the current user from session
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Helper method to check if the current user is the given user
  def current_user?(user)
    current_user == user
  end

  # Redirect users who are not signed in
  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to root_url, alert: t('auth.signin_required')
    end
  end

  # Redirect users who are not organizers
  def require_user
    unless current_user&.user?
      redirect_to root_url, alert: t('auth.unauthorized_access')
    end
  end

  # Redirect users who are not organizers
  def require_organizer
    unless current_user&.organizer?
      redirect_to root_url, alert: t('auth.unauthorized_access')
    end
  end

  # Redirect users who are not admins
  def require_admin
    unless current_user&.admin?
      redirect_to root_url, alert: t('auth.unauthorized_access')
    end
  end

  # Set the locale for the application
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
