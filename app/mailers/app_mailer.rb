class AppMailer < ActionMailer::Base
  def notify_on_new_to(user, todo)
    @todo = todo
    mail from: "info@todoapp.com", to: user.email, subject: "You create a new todo"
  end
end