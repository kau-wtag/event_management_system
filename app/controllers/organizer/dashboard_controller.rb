module Organizer
  class DashboardController < ApplicationController
    layout 'organizer'
    before_action :require_signin
    before_action :require_organizer

    def index
      # Get all events created by the current organizer
      @events = current_user.events
    end
  end
end
