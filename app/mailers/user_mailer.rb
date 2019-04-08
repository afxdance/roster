class UserMailer < ApplicationMailer
  default from: 'afxroster@gmail.com'

  def example_email
    mail(bcc: Dancer.pluck(:email), subject: 'test')
  end

  def audition_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for auditioning!')
  end

end
