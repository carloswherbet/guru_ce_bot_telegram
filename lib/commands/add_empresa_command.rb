require_relative '../company.rb'
class AddEmpresaCommand
  def self.call bot, message
    message_menu_callback = (message.message rescue nil) || message
    if (message_menu_callback.chat && !$admin_users.include?(message_menu_callback.chat.username))  || ['group', 'supergroup'].include?(message_menu_callback.chat.type)
      bot.api.send_message(chat_id: message_menu_callback.chat.id, text: "Desculpe, por enquanto somente usuários Administradores podem adicionar empresas.\n\nSolciite a adição da empresa no chat privado de @carloswherbet.", date: message.date)
    else
      case message
      when Telegram::Bot::Types::CallbackQuery
        msg = "Para adicionar uma empresa use o comando: \n ```\n/add_empresa  Nome da Empresa, Url da empresa(Não Obrigatório)```"
        bot.api.send_message(chat_id: message.message.chat.id, text: "#{msg}", date: message.message.date, parse_mode: 'Markdown')
      else
        message = (message.message rescue nil) || message
        row = message.text.gsub('/add_empresa','').split(',')
        if row.size > 0
          company = Company.new(
            name: row[0].strip,
            url: (row[1].strip rescue nil),
            username: message.chat.username
          )
          company.create
          msg = "	\xE2\x9C\x85 Empresa adiciona! \n"
          bot.api.send_message(chat_id: message.chat.id, text: "#{msg}", date: message.date)
          Menu.call(bot, message, 'menu_inicial')
          msg_group = "\xE2\x9C\x85 Uma nova empresa Ruby #{company.name} foi adicionada. 🤖\n\nPara saber mais use o comando abaixo ou converse comigo no privado: ```\n /\menu```"
          Bot.speak_to_group(bot, message){msg_group}

        else
          bot.api.send_message(chat_id: message.chat.id, text: "/add_empresa", date: message.date)
        end
      end
    end
  end
end