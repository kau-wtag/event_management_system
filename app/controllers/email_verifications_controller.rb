class EmailVerificationsController < ApplicationController
  def verify
    user = User.find_by(verification_token: params[:token])

    if user && !user.email_verified
      user.update(email_verified: true, verification_token: nil)
      flash[:notice] = "Your email has been successfully verified."
      redirect_to new_session_path
    else
      flash[:alert] = "Invalid or expired verification link."
      redirect_to root_path
    end
  end
end
