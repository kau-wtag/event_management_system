class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      UserMailer.password_reset(user).deliver_now
      flash[:notice] = "Password reset instructions have been sent to your email."
      redirect_to root_path
    else
      flash[:alert] = "Email not found."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @token = params[:token]
    @user = User.find_by(reset_password_token: @token)
    if @user.nil? || !@user.password_reset_token_valid?
      flash[:alert] = "Password reset link is invalid or has expired."
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user.nil?
      flash[:alert] = "Password reset link is invalid or has expired."
      redirect_to new_password_reset_path
    else
      if @user.update!(password_params)
        @user.update!(reset_password_token: nil) # Clear the reset token after successful update
        @user.update!(reset_password_sent_at: nil) # Clear the reset token after successful update
        flash[:notice] = "Password has been reset successfully."
        redirect_to new_session_path
      else
        flash.now[:alert] = "Password reset failed. Please check the form for errors."
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end