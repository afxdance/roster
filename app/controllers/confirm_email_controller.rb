class ConfirmEmailController < ApplicationController
  def index

  end

  def click
    SendConfirmationEmailJob.perform_later
    render "click"
  end
end
