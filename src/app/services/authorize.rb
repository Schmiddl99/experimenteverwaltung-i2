class Authorize
  def initialize(user: nil, controller: nil, action: nil)
    @user = user
    @controller = controller.to_s
    @action = action.to_s
  end

  def allow?
    role = roles[user_role]
    @controller.include?("devise/") ||
      role.present? && role[@controller].present? &&
        (
          role[@controller] == "all" ||
          role[@controller].include?(@action)
        )
  end

  def can_save?
    not_allow = [:update, :create, :destroy]
    (@user.try(:username) != "demo" || @controller.include?("devise")) || !not_allow.include?(@action.to_sym)
  end

  def disallow?
    !(allow? && can_save?)
  end

  private

  def roles
    yaml = YAML.load_file('config/roles.yml')
    yaml["roles"]
  end

  def user_role
    @user.try(:role)
  end
end
