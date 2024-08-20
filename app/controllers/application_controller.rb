class ApplicationController < ActionController::Base
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from StandardError, with: :standard_error

  # private

  # def record_not_found(exception)
  #   redirect_to root_path, alert: "Record not found: #{exception.message}"
  # end

  # def record_invalid(exception)
  #   redirect_back fallback_location: root_path, alert: "Invalid record: #{exception.message}"
  # end

  # def standard_error(exception)
  #   redirect_back fallback_location: root_path, alert: "An error occurred: #{exception.message}"
  # end

private

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
      redirect_to new_session_url, alert: "Please sign in first"
    end
  end

  def require_admin
    unless current_user.admin?
      redirect_to events_url, alert: "Unauthorized access!"
    end
  end
end
