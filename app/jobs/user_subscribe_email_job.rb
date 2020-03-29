class UserSubscribeEmailJob < ApplicationJob
  queue_as :default

  def perform(email)
    SubscribeMailer.subscribe(email).deliver_now
    # Do something later
  end
end
