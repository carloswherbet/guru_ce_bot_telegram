require_relative '../company.rb'
class ListEmpresasCommand
  def self.call bot, message
    companies = Company.all.map{|i| i.to_s}.join("\n")
    values = companies == '' ? "Sem empresas cadastradas" : companies
    message = (message.message rescue nil) || message
    
    bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text: "* Lista das #{Company.all.size} empresas de tecnologia que trabalham com Ruby \n\n*", date: message.date, disable_web_page_preview: true)
    bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text: "#{values}\n", date: message.date, disable_web_page_preview: true)
  end

end