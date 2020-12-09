module ApplicationHelper
  def footer(&block)
    @disabel_footer = true
    render partial: "layouts/footer", locals: { button: yield }
    # yield
  end
end
