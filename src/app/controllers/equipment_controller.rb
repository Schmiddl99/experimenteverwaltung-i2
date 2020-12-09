class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]

  # GET /equipment
  def index
    @equipment = Equipment.where(adhoc: false).order(Arel.sql("lower(name)")).paginate(page: params[:page])
  end

  # GET /equipment/1
  def show
    respond_to do |format|
      format.html {
        render :show
      }
      format.json {
        render json: @equipment
      }
    end
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end

  # GET /equipment/1/edit
  def edit
    if params[:exchange].present?
      @equipment.name = nil
      @equipment.location = nil
      @equipment.inventory_nr = nil
    end
  end

  # POST /equipment
  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      respond_to do |format|
        format.html {
          redirect_to equipment_index_url, notice: "#{I18n.t('activerecord.models.equipment', default: 'Equipment')} #{I18n.t('notice.create')}"
        }
        format.json {
          render json: { id: @equipment.id }
        }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /equipment/1
  def update
    if @equipment.update(equipment_params)
      respond_to do |format|
        format.html {
          redirect_to equipment_index_url, notice: "#{I18n.t('activerecord.models.equipment', default: 'Equipment')} #{I18n.t('notice.update')}"
        }
        format.json {
          render json: { id: @equipment.id }
        }
      end
    else
      render :edit
    end
  end

  # DELETE /equipment/1
  def destroy
    @equipment.destroy
    redirect_to equipment_index_url, notice: "#{I18n.t('activerecord.models.equipment', default: 'Equipment')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def equipment_params
    params.require(:equipment).permit(:name, :location, :inventory_nr, :adhoc)
  end
end
