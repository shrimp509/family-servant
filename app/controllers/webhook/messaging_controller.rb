require 'line/bot'

class Webhook::MessagingController < Webhook::ApplicationController
  before_action :messaging_params, only: :hello
  before_action :setup_client, only: :hello
  before_action :setup_events, only: :hello
  before_action :setup_event_type, only: :hello
  before_action :setup_reply_token, only: :hello
  before_action :setup_message, only: :hello
  before_action :setup_source_type, only: :hello
  before_action :setup_group_id, only: :hello
  before_action :setup_user_id, only: :hello

  def hello
    case @event_type
    when :memberJoined
      reply('嗨嗨新成員你好')
    when :message
      if @message.include?('僕人') && (@message.include?('出門') || @message.include?('回家'))
        response = LineApi.username_from(@user_id)
        if response['status'] == 200
          @username = response['displayName']
        end
        @action = '出門' if @message.include?('出門')
        @action = '回家' if @message.include?('回家')
        reply("好的，#{@username}#{@action}了")
      end
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

  def setup_events
    @events = params[:events]
  end

  def setup_event_type
    @event_type = @events.first[:type].to_sym
  end

  def setup_reply_token
    @reply_token = @events.first[:replyToken]
  end

  def setup_client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = '509537605e34d24317b42b5b3eeb9423'
      config.channel_token = '3Tq2rfMNvdTgNz9eRmcBOdSf2/QYAHA9H9ltFtwn2sWJ2/f2z4QZDLsztbCBDfdz6nRgT3ZoSeQSSzdmCwxCw4F5rD6YGYsKRBHEseHQznGaaOSToft09ypVtcG7m14D225py9updhs8N0aOH7pxVwdB04t89/1O/w1cDnyilFU='
    end
  end

  def setup_message
    @message = @events.first.dig(:message, :text)
  end

  def setup_source_type
    @source_type = @events.first.dig(:source, :type).to_sym
  end

  def setup_group_id
    @group_id = @events.first.dig(:source, :groupId)
  end

  def setup_user_id
    @user_id = @events.first.dig(:source, :userId)
  end

  def reply(text)
    @client.reply_message(@reply_token, {type: 'text', text: text})
  end
end
