class Api::V1::UtilsController < ApplicationController
  def subscribe
    puts params[:subscribe][:email]
    puts "-----------------"
    render json: {status: 'ok'}
  end
end
