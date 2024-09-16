class EventsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @events = Event.all

    # Search filtering
    if params[:search].present?
      @events = @events.search_by_name_and_description(params[:search])
    end

    # Category filtering
    if params[:category].present?
      @events = @events.where(category_id: params[:category])
    end

    # Location filtering
    if params[:location].present?
      @events = @events.where('location ILIKE ?', "%#{params[:location]}%")
    end

    # Price range filtering
    if params[:min_price].present? && params[:max_price].present?
      @events = @events.where(price: params[:min_price]..params[:max_price])
    end

    # Date range filtering
    if params[:start_date].present? && params[:end_date].present?
      @events = @events.where(starts_at: params[:start_date]..params[:end_date])
    end

    # Pagination with per page selection
    per_page = params[:per_page] || 10
    @events = @events.page(params[:page]).per(per_page)
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
