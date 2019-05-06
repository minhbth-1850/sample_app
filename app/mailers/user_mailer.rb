class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("message.activated.subject_mail")
  end

  def password_reset
    @greeting = t("message.activated.greet_mail")
    mail to: "to@example.org"
  end
end
