class ConfirmEmailController < ApplicationController
  def index

  end

  def click
    #SendConfirmationEmailJob.perform_later
    Dancer.where(confirm_email_sent: false).each do |dancer|
      mail = UserMailer.welcome_email(dancer.id)
      mail.deliver_now
      dancer.confirm_email_sent = true
      dancer.save
      #mail.deliver_later
      #mail.deliver_now
    end
    render "click"
  end
end
