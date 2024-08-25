class EventMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def event_updated(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: 'Event Updated')
  end
end
