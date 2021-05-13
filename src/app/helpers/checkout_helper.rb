module CheckoutHelper
  def add_experiment_to_order_link(experiment)
    link_to(
      add_experiment_checkout_path(experiment_id: experiment.id),
      method: :patch,
      remote: true,
    ) do
      icon("fas", "cart-plus")
    end
  end

  def remove_experiment_from_order_link(ordered_experiment)
    link_to(
      remove_experiment_checkout_path(experiment_sort: ordered_experiment.sort),
      method: :delete,
      remote: true,
      class: 'text-warning'
    ) do
      icon("fas", "shopping-cart")
    end
  end
end
