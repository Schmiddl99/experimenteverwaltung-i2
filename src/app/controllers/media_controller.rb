class MediaController < ApplicationController
  before_action :set_medium, only: [:show, :edit, :update, :destroy]

  # GET /media
  def index
    @media = Medium.where(experiment: nil).order("created_at DESC").paginate(page: params[:page])
  end

  # GET /media/1
  def show
  end

  # GET /media/new
  def new
    @medium = Medium.new
  end

  # GET /media/1/edit
  def edit
    @experiment = Experiment.order('label').all
  end

  # POST /media
  def create
    @medium = Medium.new(medium_params)

    if @medium.save
      redirect_to @medium, notice: "#{I18n.t('activerecord.models.medium', default: 'Medium')} #{I18n.t('notice.create')}"
    else
      render :new
    end
  end

  # PATCH/PUT /media/1
  def update
    if @medium.update(medium_params)
      redirect_to media_url, notice: "#{I18n.t('activerecord.models.medium', default: 'Medium')} #{I18n.t('notice.update')}"
    else
      render :edit
    end
  end

  # DELETE /media/1
  def destroy
    @medium.destroy
    redirect_to media_url, notice: "#{I18n.t('activerecord.models.medium', default: 'Medium')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_medium
    @medium = Medium.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def medium_params
    params.require(:medium).permit(:experiment_id)
  end
end
