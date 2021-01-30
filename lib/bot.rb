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
    begin
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.deleteWebhook
        bot.listen do |message|
          p 'Ping'
          @message = message
          plz_not_flood_the_group(bot, message) do
            case message
            when Telegram::Bot::Types::Message
              ProxyCommand.call(bot, message)
            when Telegram::Bot::Types::CallbackQuery
              if message.data =~ /^menu_/
                Menu.call(bot, message, message.data)
              else
                ProxyCommand.call(bot, message, message.data)
              end
            end
          end
        end
      end
    rescue => exception
      p exception.message
    end

  end

  def plz_not_flood_the_group bot, message
    if (message.methods.include?(:chat) && [ 'group', 'supergroup'].include?(message.chat.type)  &&
      (!message.left_chat_member && message.new_chat_members.size == 0))

      # bot.api.send_message(chat_id: message.chat.id, text: "@#{message.from.username}, mandei no privado um bocado de coisas que sei fazer.")
      Message.welcome(bot, message) 
      Message.send(bot,message){['Digite ou Clique em /menu para acessar o menu principal']}
    elsif (message.left_chat_member rescue nil) 
      # Dummy
    elsif ((message.new_chat_members.size >0 ) rescue nil)
      members =  message.new_chat_members.map{|m| m.first_name}
      welcome_new_members = members.size == 1 ? "seja bem-vindo! 🤖" : "sejam bem-vindos ao Grupo de Usuários Ruby do Ceará! 🤖" 
      bot.api.send_message(chat_id: message.chat.id, text: "Olá #{members.join(',')}, #{welcome_new_members}")
    else
      yield
    end
  end

end
