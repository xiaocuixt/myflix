class AppMailer < ActionMailer::Base
  def notify_on_new_to(user, todo)
    @todo = todo
    mail from: "info@todoapp.com", to: user.email, subject: "You create a new todo"
  end

  def send_welcome_email(user)
    @user = user
    mail from: "info@myfix.com", to: user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail from: "info@myfix.com", to: user.email, subject: "Please reset your password!"
  end
end