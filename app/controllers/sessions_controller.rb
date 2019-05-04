class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_back_or user
    else
      flash[:danger] = t "message.fail_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def remember_check checked, user
    if checked == Settings.conditions.checked
      remember user
    else
      forget user
    end
  end
end
