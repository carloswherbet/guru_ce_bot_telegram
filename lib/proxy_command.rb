require_relative 'message.rb'
require_relative 'company.rb'
require_relative 'menu.rb'
require_relative './commands/add_empresa_command.rb'
require_relative './commands/list_empresas_command.rb'
class ProxyCommand

  def self.call bot, message, command = nil
    # class_method = command.split('_').reverse
    # Object.const_get(class_method[0]).send(class_method[0])
    @bot = bot
    @message = message
    @chat_id = message.methods.include?(:chat) ? @message.chat.id  : @message.from.id
    @date = message.methods.include?(:date) ? @message.date : @message.message.date

    command = (command.gsub('/','') rescue nil) || "#{message.text} ".scan(/^\/(.*?)\s/).flatten.first

    # NOTE: need to improve
    @list_commands = methods(false)
    begin
      if command && @list_commands.include?(command.to_sym)
        send(command) 
      else
        @bot.api.send_message(chat_id: @chat_id, text: "Hey #{@message.from.first_name}, use o menu abaixo.")
        self.menu
      end
    rescue => exception
      p exception.message
      @bot.api.send_message(chat_id: @chat_id, text: "Hey mah, use o menu abaixo que fica mais facil navegar.")
    end
  end

  def self.menu
    Menu.call(@bot, @message, 'menu_inicial')
  end

  def self.sobre
    Message.send(@bot, @message) do
      [
        "*Sobre o GURU-CE Bot*\n",
        "Oi, ainda não tenho nome mas fui desenvolvido para trazer informações \
sobre o mundo Ruby para você, sei fazer coisas como:\n",
        "🔹 Mostrar a lista de empresas que trabalham com Ruby no Ceará",
        "🔸 Mostrar os eventos Ruby no Brasil(Breve)",
        "🔸 Anunciar ou pesquisar Vagas de emprego com Ruby(Breve)",
        "🔸 Você pode receber alertas automaticamente de vagas(Breve)",
        "\nPor enquanto sou apenas um BabyBot, mas breve estarei \
fazendo muito mais coisas 👾",
        "\nMeu idealizador foi o @carloswherbet e ele \
colocou meu código disponível no [github](https://github.com/carloswherbet/guru_ce_bot_telegram), então fique a vontade \ 
para me ajudar a crescer e dominar o mundo! \b Tô de Brinks! 🤖👻 \n\n",
      ]
    end
    Menu.call(@bot, @message, 'menu_inicial')
  end

  def self.add_evento
    in_construction()
  end

  def self.list_eventos
    in_construction()
  end
  
  def self.anunciar_vaga
    in_construction()
  end
  
  def self.procurar_vaga
    in_construction()
  end
  
  def self.notifiqueme_vaga
    in_construction()
  end

  def self.desativar_notifiqueme_vaga
    in_construction()
  end

  def self.list_empresas
    ListEmpresasCommand.call(@bot, @message)
  end

  def self.add_empresa
    AddEmpresaCommand.call(@bot, @message)
  end

  def self.start
    # NOTE: need Class?
    Message.welcome(@bot, @message)
    # print_commands()
    Menu.call(@bot, @message, 'menu_inicial')
  end

  def self.ajuda
    in_construction()
    # NOTE: need Class?
    # Message.welcome(@bot, @message)
    # print_commands()

  end

  private

  def self.in_construction
    Message.send(@bot, @message) do 
      [
        "🔸 *Ainda não disponível*\n",
        "Quer implementar essa Funcionalidade?",
        'Fale com @carloswherbet e ajude o projeto no [github](https://github.com/carloswherbet/guru_ce_bot_telegram)',
      ]
    end
  end

  def self.print_commands
    ajuda = "\n\n/ajuda - Retorna exatamente aqui!\n\n"
    empresas = "/get_empresas - Mostra a lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
    add_emp = "/add_empresa - Adiciona uma nova empresa à lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
    @bot.api.send_message(chat_id: @message.from.id, text: "Utilize os comandos: #{ajuda}#{empresas}#{add_emp} ")
  end

end


