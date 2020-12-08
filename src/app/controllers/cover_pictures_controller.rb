class CoverPicturesController < ApplicationController
  before_action :set_cover_picture, only: [:edit, :update, :destroy]

  # GET /cover_pictures
  def index
    @cover_pictures = CoverPicture.all.order("created_at DESC").paginate(page: params[:page])
  end

  # GET /cover_pictures/new
  def new
    @cover_picture = CoverPicture.new
  end

  # GET /cover_pictures/1/edit
  def edit
  end

  # POST /cover_pictures
  def create
    @cover_picture = CoverPicture.new(cover_picture_params)
    CoverPicture.update_all(current: false)
    @cover_picture.current = true
    if @cover_picture.save
      redirect_to cover_pictures_path, notice: "#{I18n.t('activerecord.models.cover_picture', default: 'Cover picture')} #{I18n.t('notice.create')}"
    else
      render :new
    end
  end

  # PATCH/PUT /cover_pictures/1
  def update
    CoverPicture.update_all(current: false)
    if @cover_picture.update(cover_picture_params)
      redirect_to cover_pictures_path, notice: "#{I18n.t('activerecord.models.cover_picture', default: 'Cover picture')} #{I18n.t('notice.update')}"
    else
      render :edit
    end
  end

  # DELETE /cover_pictures/1
  def destroy
    @cover_picture.destroy
    unless CoverPicture.any?(&:current?) || CoverPicture.first.nil?
      CoverPicture.first.update(current: true)
    end
    redirect_to cover_pictures_url, notice: "#{I18n.t('activerecord.models.cover_picture', default: 'Cover picture')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_cover_picture
    @cover_picture = CoverPicture.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def cover_picture_params
    params.require(:cover_picture).permit(:current, :file)
  end
end
