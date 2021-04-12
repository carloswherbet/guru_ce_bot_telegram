require 'pry'
class Message

  def self.send(bot, message)
    bot.api.send_message(chat_id: message.from.id, text: (yield.join("\n")), parse_mode: 'Markdown') rescue nil
  end

  def self.welcome(bot, message)
    bot.api.send_message(chat_id: message.from.id, text: "Olá, #{message.from.first_name}, boas-vindas ao Bot do Grupo do Usuários Ruby do Ceará \n") rescue nil
  end
end
