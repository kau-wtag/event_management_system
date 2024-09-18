class FollowsController < ApplicationController
  before_action :require_signin
  before_action :require_user

  def create
    @organizer = User.find(params[:organizer_id])
    current_user.following << @organizer
    redirect_back fallback_location: event_path(params[:event_id]), notice: "You are now following #{@organizer.name}."
  end

  def destroy
    @organizer = User.find(params[:organizer_id])
    current_user.following.delete(@organizer)
    redirect_back fallback_location: event_path(params[:event_id]), notice: "You have unfollowed #{@organizer.name}."
  end
end
