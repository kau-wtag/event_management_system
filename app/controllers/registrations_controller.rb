class RegistrationsController < ApplicationController

  before_action :require_signin

  def index
    @event = Event.find(params[:event_id])
    @registrations = @event.registrations
  end

  def new
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
  end

  def create
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
    @registration.user = current_user
    if @registration.save
      UserMailer.registration_confirmation(current_user, @event).deliver_later
      redirect_to event_registrations_url(@event), notice: "Thanks for registering!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
