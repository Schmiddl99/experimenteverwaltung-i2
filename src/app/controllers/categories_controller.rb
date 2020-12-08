class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.order("created_at DESC").paginate(page: params[:page])
  end

  # GET /categories/1
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: "#{I18n.t('activerecord.models.category', default: 'Category')} #{I18n.t('notice.create')}"
    else
      render :new
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to @category, notice: "#{I18n.t('activerecord.models.category', default: 'Category')} #{I18n.t('notice.update')}"
    else
      render :edit
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: "#{I18n.t('activerecord.models.category', default: 'Category')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:name, :label, :priority)
  end
end
