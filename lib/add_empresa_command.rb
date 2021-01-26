class AddEmpresaCommand
  def self.call bot, message
    if (message.chat && message.chat.username != 'carloswherbet') || message.chat.type == "group"
        bot.api.send_message(chat_id: message.chat.id, text: "Desculpe, por enquanto somente usuários Administradores podem adicionar empresas.\n\nSolciite a adição da empresa no chat privado de @carloswherbet.", date: message.date)
      else
        if message.text.strip == '/add_empresa'
          msg = "Para adicionar uma empresa use o comando: \n /add_empresa  Nome da Empresa, Url da empresa(Não Obrigatório)"
          bot.api.send_message(chat_id: message.chat.id, text: "#{msg}", date: message.date)
        else
          # bot.api.send_message(chat_id: message.chat.id, text: "Olá, #{message.chat.first_name}, as instruções para adicionar uma empresa foi passado no chat privado")
          row = message.text.gsub('/add_empresa','').split(',')

          if row.size > 0
            company = Company.new(
              name: row[0].strip,
              url: (row[1].strip rescue nil),
              username: message.chat.username
            )
            company.create
            msg = "	\xE2\x9C\x85 Empresa adiciona! \n\n Digite /get_empresas para ver a lista"
            bot.api.send_message(chat_id: message.from.id, text: "#{msg}", date: message.date)
          else
            bot.api.send_message(chat_id: message.from.id, text: "/add_empresa", date: message.date)
          end
        end
      end
  end

end