class EventsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    if params[:search].present?
      @events = Event.search_by_name_and_description(params[:search]).page(params[:page]).per(10)
    else
      @events = Event.all.page(params[:page]).per(2)
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to event_path(@event), notice: t('events.messages.created')
    else
      flash.now[:alert] = t('events.messages.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event), notice: t('events.messages.updated')
    else
      flash.now[:alert] = t('events.messages.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, notice: t('events.messages.deleted'), status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :price, :starts_at, :capacity, :image)
  end
end
