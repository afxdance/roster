class UserMailer < ApplicationMailer
  default from: 'afxroster@gmail.com'


  def audition_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for auditioning!')
  end

  def email_to_all(params)
    @params = params
    mail(bcc: Dancer.pluck(:email), subject: @params.subject)
  end

end
