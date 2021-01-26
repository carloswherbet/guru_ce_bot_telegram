require 'telegram/bot'
require_relative 'db_migrate.rb'
require_relative 'message.rb'
require_relative 'company.rb'
require_relative 'proxy_command.rb'
require 'dotenv/load'
require 'pry'
class Bot
  def initialize
    token = ENV['TOKEN']
    Telegram::Bot::Client.run(token) do |bot|
      bot.api.deleteWebhook
      bot.listen do |message|
        puts 'Ping'
        ProxyCommand.call(bot, message)
      end

    end
  end

end
