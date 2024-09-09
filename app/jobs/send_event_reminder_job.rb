class SendEventReminderJob < ApplicationJob
  queue_as :default

  def perform(event)
    event.users.each do |user|
      EventMailer.reminder_email(user, event).deliver_later
    end
  end
end
