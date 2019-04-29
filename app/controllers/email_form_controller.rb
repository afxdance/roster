class EmailFormController < ApplicationController

  def index
    @request = EmailForm.new
    render "email_form/index"
  end

  def create_email_form
    @request = EmailForm.new(request_params)
    success = @request.save

    if success
      UserMailer.email_to_all(@request).deliver_now
      render "email_form/confirm"
    else
      render "email_form/index"
    end

  end


  def request_params
    params.require(:email_form).permit(
      :subject,
      :body,
    )
  end

end
