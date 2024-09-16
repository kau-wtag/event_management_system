class CommentsController < ApplicationController
  before_action :require_signin
  before_action :set_event

  def create
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to event_path(@event), notice: t('events.messages.comment_created')
    else
      redirect_to event_path(@event), alert: t('events.messages.comment_failed')
    end
  end

  def destroy
    @comment = @event.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to event_path(@event), notice: t('events.messages.comment_deleted')
    else
      redirect_to event_path(@event), alert: t('events.messages.comment_delete_not_authorized')
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
