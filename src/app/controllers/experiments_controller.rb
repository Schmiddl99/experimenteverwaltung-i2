class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :pdf, :edit, :update, :destroy, :restore]

  # GET /experiments
  def index
    @experiments = Experiment
    if params[:q].present?
      # % innerhalb des Strings erkennt es nicht an, zumindest '%O' erkennt es als attribut
      @experiments = @experiments.where("LOWER(name) LIKE ? OR LOWER(label) LIKE ?", '%' + params[:q].downcase + '%', '%' + params[:q].downcase + '%')
    end
    if params[:c].present?
      @experiments = @experiments.where("sub_category_id = ?", params[:c])
    end
    @experiments = @experiments.order("created_at DESC").active.paginate(page: params[:page])
  end

  # GET /experiments/show
  def show
  end

  def pdf
    render pdf: "test", template: 'experiments/card'
  end

  # GET /experiments/download
  def download
    document = Document.find(params[:document])
    dfile = document.try(:file).try(:path)
    if dfile.present?
      send_file dfile, filename: document.file.original_filename
    end
  end

  # GET /experiments/trash
  def trash
    @experiments = Experiment.deleted.order("created_at DESC").paginate(page: params[:page])
  end

  # GET /experiments/new
  def new
    @experiment = Experiment.new
    @experiment.build_relationships
  end

  # GET /experiments/1/edit
  def edit
    @experiment.build_relationships
  end

  # POST /experiments
  def create
    @experiment = Experiment.new(experiment_params)
    @experiment.user = current_user
    if @experiment.save
      redirect_to @experiment, notice: "#{I18n.t('activerecord.models.experiment', default: 'Experiment')} #{I18n.t('notice.create')}"
    else
      @experiment.build_relationships
      render :new
    end
  end

  # PATCH/PUT /experiments/1
  def update
    new_params = experiment_params
    new_params[:media_attributes].each do |index, obj|
      next if obj["id"].blank?
      m = Medium.find_by(id: obj["id"])
      next if m.blank?
      if obj["_destroy"] == "1"
        m.update(experiment: nil)
        new_params[:media_attributes].delete(index)
      else
        m.update(sort: obj["sort"])
      end
    end
    if @experiment.update(new_params)
      redirect_to @experiment, notice: "#{I18n.t('activerecord.models.experiment', default: 'Experiment')} #{I18n.t('notice.update')}"
    else
      @experiment.build_relationships
      render :edit
    end
  end

  # DELETE /experiments/1
  def destroy
    if @experiment.deleted
      @experiment.delete
      # TODO
    else
      @experiment.deleted = true
      @experiment.save(validate: false)
    end
    redirect_to "/", notice: "#{I18n.t('activerecord.models.experiment', default: 'Experiment')} #{I18n.t('notice.destroy')}"
  end

  def restore
    @experiment.deleted = false
    @experiment.save(validate: false)
    redirect_to @experiment, notice: "#{I18n.t('activerecord.models.experiment', default: 'Experiment')} #{I18n.t('notice.restore')}"
  end

  private

  def set_experiment
    @experiment = Experiment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def experiment_params
    params.require(:experiment).permit(
      :name,
      :label,
      :sub_category_id,
      :description,
      :deleted,
      :message,
      links_attributes: [:id, :url, :experiment_id, :_destroy],
      media_attributes: [:id, :sort, :file, :experiment_id, :_destroy],
      documents_attributes: [:id, :experiment_id, :file, :_destroy],
      videos_attributes: [:id, :experiment_id, :file, :_destroy],
      experiment_equipment_assignments_attributes: [:id, :equipment_id, :experiment_id, :number, :_destroy],
      experiment_danger_assignments_attributes: [:id, :equipment_id, :danger_id, :_destroy]
    )
  end
end
