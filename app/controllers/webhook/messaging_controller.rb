require 'line/bot'

class Webhook::MessagingController < Webhook::ApplicationController
  before_action :messaging_params, only: :hello
  before_action :setup_params, only: :hello

  def hello
    get_username

    case @event_type
    when :memberJoined
      reply("嗨嗨，#{@username} 你好阿")
    when :message
      deal_message
    when :join
      reply('感謝你們邀請我進群組～')
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
    @event = params[:events]&.first
    return if @event.nil?

    @event_type = @event[:type].to_sym
    @reply_token = @event[:replyToken]
    @message = @event.dig(:message, :text)
    @source_type = @event.dig(:source, :type).to_sym
    @group_id = @event.dig(:source, :groupId)
    @user_id = @event.dig(:source, :userId)

    user = User.where(line_user_id: @user_id)
    User.create(line_user_id: @user_id) if user.nil?
  end

  def reply(text)
    @client.reply_message(@reply_token, {type: 'text', text: text})
  end

  def deal_message
    case
    when @message.include?('我想記錄')
      reply('OK唷')
    when @message.include?('記錄')
      # reply('請跟我說想要記錄什麼')
      record_message_format
    when @message.include?('歷史')
      reply('想查什麼歷史紀錄呢？')
    else
      reply("嗨 #{@username} 主人，我目前有兩種功能：一個是`記錄`、一個是`歷史`哦")
    end
  end

  def get_username
    response = LineApi.username_from(@user_id)
    @username = response['displayName'] if response['status'] == 200
  end

  def record_message_format
    data = JSON.load(Rails.root.join('app/assets/messages/example_message2.json'))
    @client.reply_message(@reply_token, data)
  end
end
