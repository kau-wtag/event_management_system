module Organizer
  class EventsController < ApplicationController
    layout 'organizer'
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    before_action :require_signin
    before_action :require_organizer

    def index
      # Show only events created by the current organizer
      @events = current_user.events.order(created_at: :desc)
    end

    def show
      # @event is already set by the set_event method
    end

    def new
      @event = Event.new
    end

    def create
      @event = current_user.events.build(event_params) # Associate event with the current organizer
      if @event.save
        schedule_reminder(@event)
        redirect_to organizer_events_path, notice: 'Event successfully created.' # Redirect to organizer events index
      else
        flash.now[:alert] = 'There were errors saving the event.'
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @event is already set by the set_event method
    end

    def update
      if @event.update(event_params)
        schedule_reminder(@event)
        send_event_update_notifications(@event)
        redirect_to organizer_event_path(@event), notice: 'Event successfully updated.'
      else
        flash.now[:alert] = 'There were errors updating the event.'
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to organizer_events_path, notice: 'Event successfully deleted.', status: :see_other
    end

    private

    def schedule_reminder(event)
      # Set reminder to be sent 1 day before the event starts
      SendEventReminderJob.set(wait_until: event.starts_at - 1.day).perform_later(event)
    end

    def set_event
      @event = current_user.events.find_by(id: params[:id]) # Find event associated with the current organizer
      if @event.nil?
        redirect_to organizer_events_path, alert: 'Event not found.'
      end
    end

    def event_params
      params.require(:event).permit(:name, :description, :location, :price, :capacity, :starts_at, :registration_start_date, :registration_end_date, :image, :category_id)
    end

    def send_event_update_notifications(event)
      event.users.each do |user|
        EventMailer.event_updated(event, user).deliver_later
      end
    end
  end
end
