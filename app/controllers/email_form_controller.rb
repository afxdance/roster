class EmailFormController < ApplicationController

  def index
    @request = Email.new
    render "email/index"
  end

  def create_email
    @request = Email.new(request_params)
    success = @request.save

    render "email/index" unless success
  end

  def request_params
    params.require(:email).permit(
      :subject,
      :body,
    )
  end

end
