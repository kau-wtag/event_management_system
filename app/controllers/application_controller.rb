class ApplicationController < ActionController::Base
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from StandardError, with: :standard_error

  before_action :set_locale

  def default_url_options
    { locale: I18n.locale }
  end

  private

  # def record_not_found(exception)
  #   redirect_to root_path, alert: t('errors.record_not_found', message: exception.message)
  # end

  # def record_invalid(exception)
  #   redirect_back fallback_location: root_path, alert: t('errors.record_invalid', message: exception.message)
  # end

  # def standard_error(exception)
  #   redirect_back fallback_location: root_path, alert: t('errors.standard_error', message: exception.message)
  # end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: t('auth.signin_required')
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to events_url, alert: t('auth.unauthorized_access')
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
