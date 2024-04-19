require "telegram/bot"

class Bots::TelegramBot
  class << self
    def send_message(message)
      token = ENV["ALADIN_TELEGRAM_BOT_TOKEN"]
      channel_id = ENV["ALADIN_TELEGRAM_CHANNEL_ID"]
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: channel_id, text: message)
      end
    end
  end
end
