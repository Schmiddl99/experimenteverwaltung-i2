class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.order("created_at DESC").paginate(page: params[:page])
    @admin = false
    if User.where(role: 3).size <= 1
      @admin = true
    end
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "#{I18n.t('activerecord.models.user', default: 'User')} #{I18n.t('notice.create')}"
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to users_url, notice: "#{I18n.t('activerecord.models.user', default: 'User')} #{I18n.t('notice.update')}"
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: "#{I18n.t('activerecord.models.user', default: 'User')} #{I18n.t('notice.destroy')}"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :username, :password, :role, :active)
  end
end
