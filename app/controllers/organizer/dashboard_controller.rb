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
    end
  end
end
