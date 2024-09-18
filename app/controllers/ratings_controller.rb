class RatingsController < ApplicationController
  before_action :require_signin
  before_action :require_user
  before_action :set_event

  def new
    @rating = @event.ratings.build
  end

  def create
    @rating = @event.ratings.build(rating_params)
    @rating.user = current_user

    if @rating.save
      redirect_to @event, notice: 'Thank you for your review!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @rating = current_user.ratings.find_by(event_id: @event.id)
  end

  def update
    @rating = current_user.ratings.find_by(event_id: @event.id)

    if @rating.update(rating_params)
      redirect_to @event, notice: 'Your review has been updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rating = current_user.ratings.find_by(event_id: @event.id)
    @rating.destroy
    redirect_to @event, notice: 'Your review has been deleted.', status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def rating_params
    params.require(:rating).permit(:rating, :review)
  end
end
