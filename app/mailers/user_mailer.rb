class UserMailer < ApplicationMailer
  def welcome_email(dancer_id)
    @dancer = Dancer.find(dancer_id)

    mail(   :to      => @dancer.email,
            :subject => "Thanks for auditioning!"
    ) do |format|
      format.text
      format.html
    end
  end
end
