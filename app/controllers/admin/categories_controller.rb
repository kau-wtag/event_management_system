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
        redirect_to admin_category_path(@category), notice: t('admin.categories.messages.created')
      else
        flash[:alert] = t('admin.categories.messages.save_error')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @category is already set by set_category
    end

    def update
      if @category.update(category_params)
        redirect_to admin_category_path(@category), notice: t('admin.categories.messages.updated')
      else
        flash[:alert] = t('admin.categories.messages.save_error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: t('admin.categories.messages.deleted'), status: :see_other
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end
  end
end
