class RegistrationsController < ApplicationController
  before_action :require_signin
  before_action :require_user

  def index
    @event = Event.find(params[:event_id])
    @registrations = @event.registrations
  end

  def new
    @event = Event.find(params[:event_id])

    # Check if the user is already registered for this event
    if @event.registrations.exists?(user: current_user)
      redirect_to event_path(@event), alert: 'You have already registered for this event.'
    else
      # Find any other events that the user is registered for that overlap in time
      @registration = @event.registrations.new
      @conflicting_events = current_user.registrations.joins(:event).where(events: { starts_at: @event.starts_at.to_date.all_day }).where.not(events: { id: @event.id }).map(&:event)
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
    @registration.user = current_user
    if @registration.save
      UserMailer.registration_confirmation(current_user, @event).deliver_later
      redirect_to event_registrations_url(@event), notice: t('registrations.notices.success')
    else
      render :new, status: :unprocessable_entity
    end
  end
end
