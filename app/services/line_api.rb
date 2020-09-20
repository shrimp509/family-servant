class LineApi
  REQUESTER = JsonRequester.new('https://api.line.me/v2/bot')
  CHANNEL_ACCESS_TOKEN = '3Tq2rfMNvdTgNz9eRmcBOdSf2/QYAHA9H9ltFtwn2sWJ2/f2z4QZDLsztbCBDfdz6nRgT3ZoSeQSSzdmCwxCw4F5rD6YGYsKRBHEseHQznGaaOSToft09ypVtcG7m14D225py9updhs8N0aOH7pxVwdB04t89/1O/w1cDnyilFU='

  class << self
    def username_from(user_id)
      path = "profile/#{user_id}"
      headers = { 'Authorization': bearer_token }
      REQUESTER.http_send(:get, path, {}, headers)
    end

    def bearer_token
      "Bearer #{CHANNEL_ACCESS_TOKEN}"
    end
  end
end
