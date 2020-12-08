class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: [:show, :edit, :update, :destroy]

  # GET /sub_categories
  def index
    @sub_categories = SubCategory.order("created_at DESC").paginate(page: params[:page])
  end

  # GET /sub_categories/1
  def show
  end

  # GET /sub_categories/new
  def new
    @sub_category = SubCategory.new
  end

  # GET /sub_categories/1/edit
  def edit
  end

  # POST /sub_categories
  def create
    @sub_category = SubCategory.new(sub_category_params)

    if @sub_category.save
      redirect_to @sub_category, notice: "#{I18n.t('activerecord.models.sub_category', default: 'Sub category')} #{I18n.t('notice.create')}"
    else
      render :new
    end
  end

  # PATCH/PUT /sub_categories/1
  def update
    if @sub_category.update(sub_category_params)
      redirect_to @sub_category, notice: "#{I18n.t('activerecord.models.sub_category', default: 'Sub category')} #{I18n.t('notice.update')}"
    else
      render :edit
    end
  end

  # DELETE /sub_categories/1
  def destroy
    @sub_category.destroy
    redirect_to sub_categories_url, notice: "#{I18n.t('activerecord.models.sub_category', default: 'Sub category')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_sub_category
    @sub_category = SubCategory.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sub_category_params
    params.require(:sub_category).permit(:name, :label, :category_id)
  end
end
