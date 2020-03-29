class SubscribeMailer < ApplicationMailer
  def subscribe(email)
    @email = email
    mail to:@email, subject:"感謝訂閱my_citiesocial"
  end
end
