module Admin
  class CategoriesController < ApplicationController
    layout 'admin' 
    before_action :require_signin
    before_action :require_admin
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.all.order(created_at: :desc)
    end

    def show
      # @category is already set by set_category
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_category_path(@category), notice: 'Category was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @category is already set by set_category
    end

    def update
      if @category.update(category_params)
        redirect_to admin_category_path(@category), notice: 'Category was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully deleted.', status: :see_other
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def require_admin
      redirect_to root_path, alert: "Access Denied!" unless current_user&.admin?
    end

    def require_signin
      redirect_to new_session_path, alert: "Please sign in first!" unless current_user
    end
  end
end
