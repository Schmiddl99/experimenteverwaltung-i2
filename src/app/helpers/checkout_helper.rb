module CheckoutHelper
  # Generates a link to add an {Experiment} to a order.
  #
  # @author Richard Böhme
  #
  # @param [Experiment] experiment that should be added
  # @return [Temple::HTML::SafeString] the link's html
  def add_experiment_to_order_link(experiment)
    link_to(
      add_experiment_checkout_path(experiment_id: experiment.id),
      method: :patch,
      remote: true,
    ) do
      icon("fas", "cart-plus")
    end
  end

  # Generates a link for removing an ordered experiment from an order.
  #
  # @author Richard Böhme
  # @param [OrderedExperiment] ordered_experiment that should be removed
  # @return [Temple::HTML::SafeString] the link's html
  def remove_experiment_from_order_link(ordered_experiment, icon: "shopping-cart", **opts)
    link_to(
      remove_experiment_checkout_path(experiment_sort: ordered_experiment.sort),
      method: :delete,
      remote: true,
      class: "text-warning",
      **opts
    ) do
      icon("fas", icon)
    end
  end

  # Generates a link to cancel the order. This accounts for whether
  # the order is persisted or not.
  #
  # @author Richard Böhme
  # @return [Temple::HTML::SafeString] the link's html
  def cancel_order_link
    if @order.new_record?
      link_to(
        "Buchung abbrechen",
        checkout_path,
        method: :delete,
        class: "btn btn-light",
        data: { confirm: "Wollen Sie die Buchung wirklich abbrechen?" }
      )
    else
      link_to(
        "Bearbeiten abbrechen",
        checkout_path,
        method: :delete,
        class: "btn btn-light",
        data: { confirm: "Wollen Sie das Bearbeiten der Buchung wirklich abbrechen?" }
      )
    end
  end

end
