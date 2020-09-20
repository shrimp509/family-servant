class Webhook::MessagingController < Webhook::ApplicationController

  def hello
    binding.pry

    head :ok
  end
end
