class EventsController < ApplicationController
  before_action :require_signin, except: [:index, :show]

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

  def show
    @event = Event.find(params[:id])
  end
end
