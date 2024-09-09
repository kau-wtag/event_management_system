class EventMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def event_updated(event, user)
    @event = event
    @user = user
    mail(to: @user.email, subject: 'Event Updated')
  end

  def reminder_email(user, event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "Reminder: Upcoming Event - #{@event.name}")
  end
end
