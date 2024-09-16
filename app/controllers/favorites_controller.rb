class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_event

  def create
    @favorite = @event.favorites.build(user: current_user)
    if @favorite.save
      redirect_to event_path(@event), notice: 'Event added to favorites.'
    else
      redirect_to event_path(@event), alert: 'Failed to add event to favorites.'
    end
  end

  def destroy
    @favorite = @event.favorites.find_by(user: current_user)
    if @favorite
      @favorite.destroy
      redirect_to event_path(@event), notice: 'Event removed from favorites.'
    else
      redirect_to event_path(@event), alert: 'Event is not in your favorites.'
    end
  end

  private

  def set_event
  @event = Event.find(params[:event_id])
  end
end
