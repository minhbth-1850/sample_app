class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  def hello
    render html: "hello, world!"
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale == I18n.default_locale ? nil : I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "message.login_plz"
    redirect_to login_path
  end
end
