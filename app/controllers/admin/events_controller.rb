module Admin
  class EventsController < ApplicationController
    layout 'admin'
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    before_action :require_signin
    before_action :require_admin

    def index
      @events = Event.all.order(created_at: :desc)
    end

    def show
      # @event is already set by the set_event method
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        schedule_reminder(@event)
        redirect_to admin_event_path(@event), notice: t('admin.events.messages.event_created')
      else
        flash.now[:alert] = t('admin.events.messages.save_error', count: @event.errors.count)
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
        redirect_to admin_event_path(@event), notice: t('admin.events.messages.event_updated')
      else
        flash.now[:alert] = t('admin.events.messages.save_error', count: @event.errors.count)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to admin_events_path, notice: t('admin.events.messages.event_deleted'), status: :see_other
    end

    private

    def schedule_reminder(event)
      # Set reminder to be sent 1 day before the event starts
      SendEventReminderJob.set(wait_until: event.starts_at - 1.day).perform_later(event)
    end

    def set_event
      @event = Event.find_by(id: params[:id])
      if @event.nil?
        redirect_to admin_events_path, alert: t('admin.events.messages.event_not_found')
      end
    end

    def event_params
      params.require(:event).permit(:name, :description, :location, :price, :capacity, :starts_at, :image, :category_id)
    end

    def authenticate_admin!
      redirect_to root_path, alert: t('admin.auth.not_authorized') unless current_user&.admin?
    end

    def send_event_update_notifications(event)
      event.users.each do |user|
        EventMailer.event_updated(event, user).deliver_later
      end
    end
  end
end
