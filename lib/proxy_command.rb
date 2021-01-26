require_relative 'message.rb'
require_relative 'add_empresa_command.rb'
class ProxyCommand

  def self.call bot, message
    # class_method = command.split('_').reverse
    # Object.const_get(class_method[0]).send(class_method[0])
    @bot = bot
    @message = message
    command = "#{message.text} ".scan(/^\/(.*?)\s/).flatten.first

    # NOTE: need to improve
    @list_commands = methods(false)

    if @list_commands.include?(command.to_sym)
      send(command)
    else
      @bot.api.send_message(chat_id: @message.from.id, text: "Opção inválida, #{@message.from.first_name}, use /ajuda")
    end


  end


  def self.get_empresas
    # NOTE: Create a Class?

    @bot.api.send_message(chat_id: @message.chat.id, text: "Olá, #{@message.from.first_name}, a lista das empresas foi enviada para o chat privado.")
    companies = Company.all.map{|i| i.to_s}.join("\n")
    values = companies == "" ? "Sem empresas cadastradas" : companies

    @bot.api.send_message(chat_id: @message.from.id, text: "Lista das #{Company.all.size} empresas de tecnologia que trabalham com Ruby \n\n#{values}\n", date: @message.date, no_webpage: true)

  end

  def self.add_empresa
    AddEmpresaCommand.call(@bot, @message)
  end

  def self.start
    # NOTE: Create a Class?
    Message.welcome(@bot, @message)
    print_commands()
  end

  def self.ajuda
    # NOTE: Create a Class?
    Message.welcome(@bot, @message)
    msg = "\nInicie uma Conversa comigo @guru_ce_bot para receber as instruções de uso no chat privado"
    @bot.api.send_message(chat_id: @message.chat.id, text: msg)
    print_commands()

  end

  private

  def self.print_commands
    ajuda = "\n\n/ajuda - Retorna exatamente aqui!\n\n"
    get_empresas = "/get_empresas - Mostra a lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
    add_empresa = "/add_empresa - Adiciona uma nova empresa à lista de empresas de tecnologia que trabalham com Ruby no Ceará\n\n"
    @bot.api.send_message(chat_id: @message.chat.id, text: "Utilize os comandos: #{ajuda}#{get_empresas}#{add_empresa} ")
  end

end