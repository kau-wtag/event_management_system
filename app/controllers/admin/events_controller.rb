module Admin
  class EventsController < ApplicationController
    layout 'admin'
    before_action :set_event, only: [:show]
    before_action :require_signin
    before_action :require_admin

    def index
      @events = Event.all.order(created_at: :desc)
    end

    def show
      # @event is already set by the set_event method
    end

    private

    def set_event
      @event = Event.find_by(id: params[:id])
      if @event.nil?
        redirect_to admin_events_path, alert: t('admin.events.messages.event_not_found')
      end
    end
  end
end
