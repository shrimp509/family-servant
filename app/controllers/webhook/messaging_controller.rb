require 'line/bot'

class Webhook::MessagingController < Webhook::ApplicationController
  before_action :messaging_params, only: :hello
  before_action :setup_params, only: :hello

  def hello
    case @event_type
    when :memberJoined
      reply('嗨嗨新成員你好')
    when :message
      deal_message
    when :join
      reply('感謝你邀請我進群組～')
    when :leave
      # do nothing currently
    end

    head :ok
  end

  private
  def messaging_params
    params.permit(:events)
  end

  def setup_params
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = '509537605e34d24317b42b5b3eeb9423'
      config.channel_token = '3Tq2rfMNvdTgNz9eRmcBOdSf2/QYAHA9H9ltFtwn2sWJ2/f2z4QZDLsztbCBDfdz6nRgT3ZoSeQSSzdmCwxCw4F5rD6YGYsKRBHEseHQznGaaOSToft09ypVtcG7m14D225py9updhs8N0aOH7pxVwdB04t89/1O/w1cDnyilFU='
    end
    @events = params[:events]
    @event_type = @events.first[:type].to_sym
    @reply_token = @events.first[:replyToken]
    @message = @events.first.dig(:message, :text)
    @source_type = @events.first.dig(:source, :type).to_sym
    @group_id = @events.first.dig(:source, :groupId)
    @user_id = @events.first.dig(:source, :userId)
  end

  def reply(text)
    @client.reply_message(@reply_token, {type: 'text', text: text})
  end

  def deal_message
    if @message.include?('僕人')
      response = LineApi.username_from(@user_id)
      if response['status'] == 200
        @username = response['displayName']
      end
      @action = '出門' if @message.include?('出門')
      @action = '回家' if @message.include?('回家')
      reply("好的，#{@username}#{@action}了")
    end
  end
end
