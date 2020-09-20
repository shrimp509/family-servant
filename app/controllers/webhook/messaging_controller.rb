require 'line/bot'

class Webhook::MessagingController < Webhook::ApplicationController
  before_action :messaging_params, only: :hello
  before_action :setup_events, only: :hello
  before_action :setup_reply_token, only: :hello
  before_action :setup_client, only: :hello

  def hello
    message = {
      type: 'text',
      text: '好哦～好哦～'
    }
    @client.reply_message(@reply_token, message)
    head :ok
  end

  private
  def messaging_params
    params.permit(:events)
  end

  def setup_events
    @events = params[:events]
  end

  def setup_reply_token
    @reply_token = @events.first[:replyToken]
  end

  def setup_client
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = '509537605e34d24317b42b5b3eeb9423'
      config.channel_token = '3Tq2rfMNvdTgNz9eRmcBOdSf2/QYAHA9H9ltFtwn2sWJ2/f2z4QZDLsztbCBDfdz6nRgT3ZoSeQSSzdmCwxCw4F5rD6YGYsKRBHEseHQznGaaOSToft09ypVtcG7m14D225py9updhs8N0aOH7pxVwdB04t89/1O/w1cDnyilFU='
    end
  end
end
