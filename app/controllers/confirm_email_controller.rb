class ConfirmEmailController < ApplicationController
  def index

  end

  def click
    #SendConfirmationEmailJob.perform_later
    dancer = Dancer.find(4)
    puts "Sending email to " + dancer.email
    mail = UserMailer.welcome_email(dancer.id)
    mail.deliver_now
    #mail.deliver_later
    #mail.deliver_now




    render "click"
  end
end
