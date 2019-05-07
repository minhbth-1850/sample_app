class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("message.activated.subject_mail")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("message.password.sub_mail")
  end
end
