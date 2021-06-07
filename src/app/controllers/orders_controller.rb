class OrdersController < ApplicationController
  before_action :set_order, only: %i(edit destroy)
  before_action :check_course_at, only: %i(edit destroy)

  # Lists all orders of the current user.
  # Those are paged (max 10 per page) and ordered by +course_at+.
  #
  # @author Richard Böhme
  def index
    @orders =
      current_user.
        orders.
        order(course_at: :desc).
        includes(:course, ordered_experiments: :experiment).
        page(params[:page])
  end

  # Redirects the user to the checkout process while setting
  # the chosen order to be the one used in the process.
  # This allows to update an order.
  #
  # @author Richard Böhme
  def edit
    session[:order] = @order
    redirect_to checkout_path
  end

  # Destroys the order from the database. This will also
  # cancel an ongoing checkout process if it involves the order.
  #
  # @author Richard Böhme
  def destroy
    if session[:order]&.id == @order.id
      session.delete(:order)
    end

    if @order.destroy
      flash[:notice] = "Die Buchung wurde erfolgreich gelöscht!"
    else
      flash[:alert] = "Die Buchung konnte nicht gelöscht werden!"
    end
    redirect_to orders_path
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id].to_i)
  end

  # Checks if the +course_at+ attribute is in the future.
  # Otherwise the user will be redirected to the journal.
  #
  # @author Richard Böhme
  def check_course_at
    if @order.course_at < Time.current
      flash[:alert] = "Sie können nur Buchungen in der Zukunft bearbeiten!"
      redirect_to orders_path
    end
  end

end
