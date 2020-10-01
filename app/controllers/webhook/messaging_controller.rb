require 'line/bot'

class Webhook::MessagingController < Webhook::ApplicationController
  before_action :messaging_params, only: :hello
  before_action :setup_params, only: :hello

  BASE_URL = 'https://9c51dda29cec.ngrok.io/'

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
    when @message.include?('記錄')
      reply_record_message
    else
      reply("嗨 #{@username} 主人")
    end
  end

  def get_username
    response = LineApi.username_from(@user_id)
    @username = response['displayName'] if response['status'] == 200
  end

  def reply_record_message
    data = JSON.load(Rails.root.join('app/assets/messages/habit_list_format.json'))
    Topic.where(user_id: 1).all.each do |habit|
      data['template']['actions'] << habit_item(habit.title)
    end
    data['template']['actions'] << new_habit_item
    @client.reply_message(@reply_token, data)
  end

  def habit_item(title)
    uri_format(BASE_URL, 'new_record', {title: title})
  end

  def new_habit_item
    uri_format(BASE_URL, 'new_habit', {title: '新增想追蹤的習慣'})
  end

  def uri_format(base_url, action, params)
    uri = URI::join(base_url, 'habit_tracing', action).to_s << '?'
    params.map { |k, v| uri << "#{k}=#{v}" }
    {
      type: 'uri',
      label: params[:title],
      uri: uri
    }
  end
end
