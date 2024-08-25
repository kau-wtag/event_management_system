class UserMailer < ApplicationMailer
    default from: 'kaium.uddin2909@gmail.com'

    def registration_confirmation(user, event)
        @user = user
        @event = event
        mail(to: @user.email, subject: "Registration Confirmation for #{@event.name}")
    end

    def email_verification(user)
        @user = user
        @url  = verify_email_url(token: @user.verification_token)
        mail(to: @user.email, subject: 'Verify your email')
    end
end
