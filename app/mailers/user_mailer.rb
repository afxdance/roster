class UserMailer < ApplicationMailer
  default from: 'afxroster@gmail.com'

  def example_email
    mail(bcc: ['ckwu@berkeley.edu', 'jessie.jin@berkeley.edu', 'youngcai@berkeley.edu'], subject: 'test')
  end
end
