class DangersController < ApplicationController
  before_action :set_danger, only: [:show, :edit, :update, :destroy]

  # GET /dangers
  def index
    @dangers = Danger.where(adhoc: false).order(Arel.sql("lower(name)")).paginate(page: params[:page])
  end

  # GET /dangers/1
  def show
    respond_to do |format|
      format.html {
        render :show
      }
      format.json {
        render json: @danger
      }
    end
  end

  # GET /dangers/new
  def new
    @danger = Danger.new
  end

  # GET /dangers/1/edit
  def edit
  end

  # POST /dangers
  def create
    @danger = Danger.new(danger_params)

    if @danger.save
      respond_to do |format|
        format.html {
          redirect_to dangers_url, notice: "#{I18n.t('activerecord.models.danger', default: 'Danger')} #{I18n.t('notice.create')}"
        }
        format.json {
          render json: { id: @danger.id }
        }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /dangers/1
  def update
    if @danger.update(danger_params)
      respond_to do |format|
        format.html {
          redirect_to dangers_url, notice: "#{I18n.t('activerecord.models.danger', default: 'Danger')} #{I18n.t('notice.update')}"
        }
        format.json {
          render json: { id: @danger.id }
        }
      end
    else
      render :edit
    end
  end

  # DELETE /dangers/1
  def destroy
    @danger.destroy
    redirect_to dangers_url, notice: "#{I18n.t('activerecord.models.danger', default: 'Danger')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_danger
    @danger = Danger.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def danger_params
    params.require(:danger).permit(:name, :label, :file, :adhoc)
  end
end
