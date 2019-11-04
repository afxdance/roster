class SendConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    print("feel special")
  end
end
