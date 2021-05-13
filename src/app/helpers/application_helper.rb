module ApplicationHelper
  def footer(&block)
    @disable_footer = true
    render partial: "layouts/footer", locals: { button: yield }
  end
end
