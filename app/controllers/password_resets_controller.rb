class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expirate, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "message.password.sent_mail"
      redirect_to root_path
    else
      flash.now[:danger] = t "message.password.nil_mail"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("message.password.empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "message.password.reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return @user if @user

    flash[:danger] = t "message.nil_user"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_path
  end

  def check_expirate
    return false unless @user.password_reset_expired?

    flash[:danger] = t "message.password.expired"
    redirect_to new_password_reset_path
  end
end
