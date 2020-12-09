class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :authorize_user!

  def after_sign_in_path_for(resource)
    "/"
  end

  private

  def authorize_user!
    authorize = Authorize.new(user: current_user, controller: params[:controller], action: params[:action])
    if authorize.disallow?
      redirect_to "/", alert: "Benötigte Rechte nicht vorhanden."
    end
  end
end
