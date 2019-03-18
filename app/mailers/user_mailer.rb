class UserMailer < ApplicationMailer
  default from: 'afxroster@gmail.com'

  def example_email
    mail(bcc: 'jessie.jin@berkeley.edu', subject: 'test')
  end
end
