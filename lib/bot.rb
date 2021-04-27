require 'telegram/bot'
require_relative 'db_migrate.rb'
require_relative 'message.rb'
require_relative 'company.rb'
require_relative 'proxy_command.rb'
require_relative 'security_alert.rb'
require 'dotenv/load'
require 'pry'

class Bot
  def initialize
    token = ENV['TOKEN']
    $admin_users = ENV['ADMIN_USERS'].split(',')
    begin
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.deleteWebhook
        SecurityAlert::start! bot
        bot.listen do |message|
          p message.from.first_name
          p "#{message.chat.id}-#{message.chat.title}" rescue ''
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
      (!(message.left_chat_member rescue nil) && (message.new_chat_members.size == 0) rescue true))
      # Dummy
      # Message.welcome(bot, message)
      # Message.send(bot,message){['Digite ou Clique em /menu para acessar o menu principal']}
    elsif (message.left_chat_member rescue nil) 
      # Dummy
    elsif ((message.new_chat_members.size >0 ) rescue nil)
      members =  message.new_chat_members.map{|m| m.first_name}
      welcome = [
        "A partir de hoje temos mais uma pessoa desenvolvedora seguindo nos mesmos trilhos, boas-vindas, #{members[0]}! 🤖",
        "O mundo Ruby espera você, boas-vindas #{members[0]}! 🤖",
        "Ganhamos um reforço na nossa equipe, boas-vindas #{members[0]}! 🤖",
        "A espera acabou, , boas-vindas #{members[0]}! 🤖",
        "Olá #{members[0]}, boas-vindas! 🤖"]

      welcome_new_members = members.size == 1 ? "Boas-Vindas! 🤖" : "Boas-vindas ao Grupo de Usuários Ruby do Ceará! 🤖"
      bot.api.send_message(chat_id: message.chat.id, text: "#{welcome.sample}")
      # bot.api.send_message(chat_id: message.chat.id, text: "Olá #{members.join(',')}, #{welcome_new_members}")
    else
      yield
    end
  end

  def self.speak_to_group bot, message
    bot.api.send_message(chat_id:  ENV['GROUP_CHAT_ID'], text: yield , parse_mode: 'Markdown') rescue nil
  end

end
