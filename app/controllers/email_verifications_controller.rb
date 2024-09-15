class EmailVerificationsController < ApplicationController
  def verify
    user = User.find_by(verification_token: params[:token])

    if user && !user.email_verified
      if user.update(email_verified: true, verification_token: nil)
        flash[:notice] = t('email_verifications.verify.success')
        redirect_to new_session_path
      else
        flash[:alert] = t('email_verifications.verify.error')
        redirect_to root_path
      end
    else
      flash[:alert] = t('email_verifications.verify.invalid_token')
      redirect_to root_path
    end
  end
end
