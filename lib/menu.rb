require_relative 'company.rb'
class Menu

  def self.call bot, message, menu_name
    @bot = bot
    @message =  message

    @chat_id = @message.methods.include?(:chat) ? @message.chat.id : @message.from.id

    send(menu_name) rescue nil
  end
  private

  def self.menu_inicial

    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "Empresas Ruby Ceará", callback_data: 'menu_empresas'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "🔸Eventos Ruby Brasil", callback_data: 'menu_eventos'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "🔸Vagas Ruby", callback_data: 'menu_vagas'),
      [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "Ajuda", callback_data: '/ajuda'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "Sobre o BOT", callback_data: '/sobre')
      ]
    ]
    if $admin_users.include?(@message.from.username)
      kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "Administração", callback_data: 'menu_admin')
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    if (@message.message.message_id rescue nil)
      @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
    else
      @bot.api.send_message(chat_id: @chat_id, text: " \xF0\x9F\x93\x81	*GURU-CE BOT*\n⚠️ As opções do menu com (🔸) estão ainda em desenvolvimento.\n", reply_markup: markup, parse_mode: 'Markdown' )
    end
  end

  def self.menu_empresas
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "Ver lista de Empresas Ruby", callback_data: '/list_empresas'),
    ]
    if $admin_users.include?(@message.from.username)
      kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "Adicionar uma Empresa Ruby", callback_data: '/add_empresa')
      kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "Gerenciar Empresa Ruby", callback_data: 'menu_manage_empresas')
    end
    kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "« Voltar", callback_data: 'menu_inicial')
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb )
    @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
  end

  def self.menu_manage_empresas
    kb = []
    if $admin_users.include?(@message.from.username)
      Company.all.each do |company|
        kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{company.name}", callback_data: 'menu_manage_empresas')
        kb << [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: "Editar", callback_data: "/edit_empresa #{company.id}"),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: "Apagar", callback_data: "/destroy_empresa #{company.id}"),
        ]
        kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "-----", callback_data: 'menu_manage_empresas')

      end
    end
    kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: "« Voltar", callback_data: 'menu_empresas')
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb )
    @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
  end

  def self.menu_vagas
    kb = [
      [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "🔸Anunciar Vaga", callback_data: '/anunciar_vaga'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "🔸Procurar Vaga", callback_data: '/procurar_vaga'),
      ],
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "🔸\xF0\x9F\x94\x94 Clique para Receber Alertas de Vagas", callback_data: '/notifiqueme_vaga'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "« Voltar", callback_data: 'menu_inicial'),
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb )
    @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
  end

  def self.menu_eventos

    if $admin_users.include?(@message.from.username)
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: '🔸 Ver lista de Eventos Ruby', callback_data: '/list_eventos'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: '🔸 Adicionar Evento Ruby', callback_data: '/add_evento'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "« Voltar", callback_data: 'menu_inicial'),
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
    end
  end

  def self.menu_admin

    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Administrar Empresas', callback_data: '/admin_empresas'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Administrar Empresas', callback_data: '/admin_eventos'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "« Voltar", callback_data: 'menu_inicial'),
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    @bot.api.editMessageReplyMarkup(chat_id: @chat_id, message_id: (@message.message.message_id), reply_markup: markup)
  end
end
