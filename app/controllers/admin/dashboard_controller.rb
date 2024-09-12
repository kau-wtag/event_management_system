class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_action :require_signin
  before_action :require_admin

  def index
    @users_count = User.count
    @events_count = Event.count
    @registrations_count = Registration.count

    @recent_users = User.order(created_at: :desc).limit(5) || []
    @recent_events = Event.order(created_at: :desc).limit(5) || []
    @recent_registrations = Registration.order(created_at: :desc).limit(5) || []

    @upcoming_events = Event.upcoming.limit(5) || []
    @sold_out_events = Event.all.select(&:sold_out?) || []
    @low_registration_events = Event.where('capacity - (SELECT COUNT(*) FROM registrations WHERE registrations.event_id = events.id) > 5') || []

    @inactive_users = User.left_joins(:registrations).where(registrations: { id: nil })
                          .or(User.left_joins(:registrations).where('registrations.created_at < ?', 6.months.ago)).distinct || []
    @top_participants = User.joins(:registrations).group('users.id').order('COUNT(registrations.id) DESC').limit(5) || []
  end
end
