class UserMailer < ApplicationMailer
    default from: 'kaium.uddin2909@gmail.com'

    def registration_confirmation(user, event)
        @user = user
        @event = event
        mail(to: @user.email, subject: "Registration Confirmation for #{@event.name}")
    end
end
