require 'pry'
class Message

  def self.send(bot, message)
    yield.join('\n')
  end

  def self.welcome(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "Olá, #{message.from.first_name}, bem vindo ao Bot do Grupo do Usuários Ruby do Ceará \n")
  end
end