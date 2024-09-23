class LocationsController < ApplicationController
  before_action :set_location, only: %i[show edit update destroy]
  before_action :require_admin, except: %i[index show]

  def index
    @locations = Location.all.order(created_at: :desc)
  end

  def show; end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if location_params[:image].present? && @location.image.attached?
      @location.image.purge
    end

    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: 'Location was successfully deleted.', status: :see_other
  end

  def delete_image
    @location = Location.find(params[:id])
    @location.image.purge
    redirect_to edit_location_path(@location), notice: 'Image was successfully deleted.'
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :description, :rent_cost, :google_map_link, :full_address, :capacity,
                                     :contact_number, :contact_email, :image)
  end
end
