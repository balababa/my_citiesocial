class Api::V1::UtilsController < ApplicationController
  def subscribe
    email =  params['subscribe']['email']
    
    sub = Subscribe.new(email: email)



    if sub.save
      UserSubscribeEmailJob.perform_later(email)
      render json: {status: 'ok', email: email}
    else
      if email.empty?
        render json: {status: 'blank'}
        
      else
        render json: {status: 'duplicated', email: 'email'}
      end
    end

  end
end
