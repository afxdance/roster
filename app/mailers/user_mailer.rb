class UserMailer < ApplicationMailer
  default from: 'afxroster@gmail.com'

  def example_email
    mail(bcc: Dancer.pluck(:email), subject: 'test')
  end
end
