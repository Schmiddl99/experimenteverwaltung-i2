# Controller that handles the checkout process
#
# @author Richard Böhme
class CheckoutsController < ApplicationController
  before_action :set_order, except: %i(new create)

  # Entrypoint action for a checkout. This renders the form
  # that allows setting the course and the course_at of an order
  #
  # GET /checkouts/new
  #
  # @author Richard Böhme
  def new
    @order = Order.new
  end

  # Action for creating a checkout process. This action is called by submitting
  # the form rendered by the {#new} action. It will store the order instance in
  # the current user's session.
  #
  # POST /checkout
  #
  # @author Richard Böhme
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

  # With this action you can add a persisted or a dummy experiment to an order.
  # The experiment will be appended to the list of ordered experiments.
  #
  # PATCH /checkout/add_experiment
  #
  # @author Richard Böhme
  def add_experiment
    if params[:experiment_id].present?
      experiment = Experiment.find_by(id: params[:experiment_id].to_i)
      if experiment.present? && @order.ordered_experiments.none? { |ordered_experiment| ordered_experiment.experiment == experiment }
        flash[:notice] = "Experiment erfolgreich zur Buchung hinzugefügt!"
        @order.ordered_experiments.build(
          order: @order,
          experiment: experiment,
          sort: (@order.ordered_experiments.map(&:sort).max || 0) + 1
        )
      end
    elsif params[:dummy_experiment]
      experiment = DummyExperiment.new(name: params[:dummy_experiment][:name].to_s)
      if experiment.valid?
        flash[:notice] = "Benutzerdefiniertes Experiment erfolgreich zur Buchung hinzugefügt!"
        @order.ordered_experiments.build(
          order: @order,
          experiment: experiment,
          sort: (@order.ordered_experiments.map(&:sort).max || 0) + 1
        )
      else
        flash[:alert] = "Benutzerdefiniertes Experiment konnte nicht gespeichert werden!"
      end
    end
    redirect_back(fallback_location: root_path)
  end

  # With this action you can remove a persisted or a dummy experiment from an order.
  # The affected experiment is chosen by it's `sort`-value.
  #
  # DELETE /checkout/remove_experiment
  #
  # @author Richard Böhme
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

  # With this action a current checkout process will be aborted by removing the current
  # order from the user's session.
  #
  # DELETE /checkout
  #
  # @author Richard Böhme
  def destroy
    session.delete(:order)
    flash[:notice] = "Buchung erfolgreich abgebrochen!"
    redirect_back(fallback_location: root_path)
  end

  # This action will render a form for adding a comment or to reorder ordered experiments.
  # It is used before finishing an order.
  #
  # GET /checkout
  #
  # @author Richard Böhme
  def show
  end

  # This action will update the order's comment or the ordered experiment's
  # order. It's called by submitting the form rendered by {#show}. It's important
  # that the ordered experiment attributes are sorted. If the parameters
  # contain the key :persist the order will be persisted.
  #
  # PATCH /checkout
  #
  # @author Richard Böhme
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

  # This method will be called by the {#update} action and saves the order to the
  # database.
  #
  # @author Richard Böhme
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

  # Collects the params used by {#create}.
  #
  # @author Richard Böhme
  def create_params
    params.require(:order).permit(:course_id, :alternative_course_name, :course_at_date, :course_at_time)
  end

  # Collects the params used by {#update}.
  #
  # @author Richard Böhme
  def update_params
    params.require(:order).permit(:comment)
  end

  # Gets the order from the session. If there is no order this method
  # will redirect the user to the root path. (use with `before_action`)
  #
  # @author Richard Böhme
  def set_order
    super

    unless @order
      redirect_to root_path
    end
  end

end
