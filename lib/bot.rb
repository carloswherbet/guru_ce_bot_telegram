require 'telegram/bot'
require_relative 'company.rb'
require_relative 'db.rb'
require 'pry'
class Bot
  def initialize
    token = '[TOKEN]'
    Telegram::Bot::Client.run(token) do |bot|
      bot.api.deleteWebhook
      bot.listen do |message|
        puts "Alguem usou"
        begin
          case message.text
          when '/start'
            hello = "Olá, #{message.from.first_name}, bem vindo ao Bot do Grupo do Usuários Ruby do Ceará \n\n"
            ajuda = "\n\n/ajuda - Retorna exatamente aqui!\n\n"
            get_empresas = "/get_empresas - Mostra a lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
            add_empresa = "/add_empresa - Adiciona uma nova empresa à lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
            bot.api.send_message(chat_id: message.chat.id, text: "#{hello}Utilize os comandos: #{ajuda}#{get_empresas}#{add_empresa} ")
          when /^\/ajuda/
            msg = "\nInicie uma Conversa comigo @guru_ce_bot para receber as instruções de uso no chat privado"
            bot.api.send_message(chat_id: message.chat.id, text: "Olá, #{message.from.first_name}, bem vindo ao Bot do Grupo do Usuários Ruby do Ceará \n#{msg}")
            ajuda = "\n\n/ajuda - Retorna exatamente aqui!\n\n"
            get_empresas = "/get_empresas - Mostra a lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
            add_empresa = "/add_empresa - Adiciona uma nova empresa à lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
            bot.api.send_message(chat_id: message.from.id, text: "Utilize os comandos: #{ajuda}#{get_empresas}#{add_empresa} ")
          when /^\/add_empresa/
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
                  company = Company.new(name: row[0].strip, url: (row[1].strip rescue nil))
                  company.create(message.chat.username)
                  msg = "Empresa adiciona! \n Digite /get_empresas para ver a lista"
                  bot.api.send_message(chat_id: message.from.id, text: "#{msg}", date: message.date)
                else
                  bot.api.send_message(chat_id: message.from.id, text: "/add_empresa", date: message.date)
                end
              end
            end

          when /^\/get_empresas/
            bot.api.send_message(chat_id: message.chat.id, text: "Olá, #{message.from.first_name}, a lista das empresas foi enviada para o chat privado.")
            companies = Company.all.map{|i| i.to_s}.join("\n")

            values = companies == "" ? "Sem empresas cadastradas" : companies

            bot.api.send_message(chat_id: message.from.id, text: "Lista das #{Company.all.size} empresas de tecnologia que trabalham com Ruby \n\n#{values}\n", date: message.date, no_webpage: true)
          else
            bot.api.send_message(chat_id: message.from.id, text: "Opção inválida, #{message.from.first_name}, use /ajuda")
          end

        rescue => exception
          # Captura a excessão e não faz nada, serve apenas para evitar o script fechar
        end
      end

    end
  end

end
