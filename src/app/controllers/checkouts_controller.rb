class CheckoutsController < ApplicationController
  before_action :set_order, except: %i(new create)

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(user: current_user, **create_params)
    if @order.valid?(:checkout)
      session[:order] = @order
      flash[:notice] = "Buchung erfolgreich gestartet!"
      redirect_to root_path
    else
      flash[:alert] = "Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben."
      render 'new'
    end
  end

  def add_experiment
    if params[:experiment_id].present?
      experiment = Experiment.find_by(id: params[:experiment_id].to_i)
      if experiment.present? && @order.ordered_experiments.none? { |ordered_experiment| ordered_experiment.experiment == experiment }
        flash[:notice] = "Experiment erfolgreich zur Buchung hinzugefügt!"
        @order.ordered_experiments.build(
          experiment: experiment,
          sort: (@order.ordered_experiments.map(&:sort).max || 0) + 1
        )
      end
    elsif params[:dummy_experiment]
      experiment = DummyExperiment.new(name: params[:dummy_experiment][:name].to_s)
      if experiment.valid?
        flash[:notice] = "Benutzerdefiniertes Experiment erfolgreich zur Buchung hinzugefügt!"
        @order.ordered_experiments.build(
          experiment: experiment,
          sort: (@order.ordered_experiments.map(&:sort).max || 0) + 1
        )
      else
        flash[:alert] = "Benutzerdefiniertes Experiment konnte nicht gespeichert werden!"
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def remove_experiment
    if params[:experiment_sort].present?
      ordered = @order.ordered_experiments.find { |ordered_experiment| ordered_experiment.sort == params[:experiment_sort].to_i }
      if ordered.present?
        flash[:notice] = "Experiment erfolgreich aus der Buchung entfernt!"
        @order.ordered_experiments.delete(ordered)
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    session.delete(:order)
    flash[:notice] = "Buchung erfolgreich abgebrochen!"
    redirect_back(fallback_location: root_path)
  end

  def show
  end

  def update
    @order.ordered_experiments.sort_by(&:sort).each_with_index do |ordered_experiment, index|
      if (sort = params.dig(:order, :ordered_experiments_attributes, index.to_s, :sort))
        ordered_experiment.sort = sort.to_i
      end
    end

    @order.assign_attributes(update_params)

    if params.key?(:persist)
      persist
    else
      if @order.valid?(:checkout)
        flash[:notice] = "Änderungen erfolgreich gespeichert!"
        redirect_to checkout_path
      else
        flash[:alert] = "Fehler beim Speichern der Buchung. Bitte starten Sie die Buchung erneut."
        redirect_to new_checkout_path
      end
    end
  end

  def persist
    if @order.save
      session.delete(:order)
      render "success"
    else
      flash[:alert] = "Fehler beim Speichern der Buchung! Bitte versuchen Sie es erneut."
      render "show"
    end
  end

  private

  def create_params
    params.require(:order).permit(:course_id, :alternative_course_name, :course_at_date, :course_at_time)
  end

  def update_params
    params.require(:order).permit(:comment)
  end

  def set_order
    @order = session[:order]
    unless @order
      redirect_to root_path
    end
  end

end
