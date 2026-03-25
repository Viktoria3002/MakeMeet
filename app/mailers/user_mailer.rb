class UserMailer < ApplicationMailer
  default from: "no-reply@makemeet.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Вы успешно зарегистрировались в Make Meet")
  end
end