class Webhook::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def hello
    head :ok
  end

  private
  def success_response(data)
    render status: 200, json: {data: data}
  end

  def error_response(error_key, error_message=nil)
    render ErrorResponse.to_api(error_key, error_message)
  end
end
