module Organizer
  class DashboardController < ApplicationController
    layout 'organizer'
    before_action :require_signin
    before_action :require_organizer

    def index
      # Get all events created by the current organizer
      @events = current_user.events

      # Total number of events
      @total_events = @events.count

      # Calculate the number of upcoming events
      @upcoming_events = @events.where("starts_at > ?", Time.zone.now).count

      # Calculate the number of past events
      @past_events = @events.where("starts_at < ?", Time.zone.now).count

      # Top performing event based on the highest number of registrations
      @top_performing_event = @events.max_by { |event| event.registrations.count }

      # Least performing event based on the lowest number of registrations
      @least_performing_event = @events.min_by { |event| event.registrations.count }

      # Average registrations per event
      total_registrations = @events.sum { |event| event.registrations.count }
      @average_registrations_per_event = total_registrations.to_f / @events.count if @events.count > 0

      # Average revenue per event (calculated as event price * number of registrations)
      total_revenue = @events.sum { |event| event.price * event.registrations.count }
      @average_revenue_per_event = total_revenue.to_f / @events.count if @events.count > 0
    end
  end
end
