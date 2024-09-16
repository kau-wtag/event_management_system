class LikesController < ApplicationController
  before_action :require_signin
  before_action :set_event

  def create
    @like = @event.likes.build(user: current_user)
    if @like.save
      redirect_to event_path(@event), notice: 'You liked this event.'
    else
      redirect_to event_path(@event), alert: 'Failed to like event.'
    end
  end

  def destroy
    @like = @event.likes.find_by(user: current_user)
    if @like
      @like.destroy
      redirect_to event_path(@event), notice: 'You unliked this event.'
    else
      redirect_to event_path(@event), alert: 'You have not liked this event yet.'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
