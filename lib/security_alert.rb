require 'telegram/bot'
require 'nokogiri'
require 'open-uri'
require_relative 'db_config.rb'
require 'pry'
require 'dotenv/load'
module SecurityAlert

  def self.receive
    uri = URI.open(ENV['URL_ALERTS'])
    result = Nokogiri.XML(uri)
    rows = []
    result.xpath('//item').each do |item|
      attrs = {
        title:  item.children.search('title').text,
        link:  item.children.search('link').text,
        description:  item.children.search('description').text,
        guid:  item.children.search('guid').text,
        author:  item.children.search('author').text,
        pubDate:  DateTime.parse(item.children.search('pubDate').text),
      }
      rows << attrs
    end
    rows
  end

  def self.start! bot
    return if $started_alerts
    $started_alerts ||= true
    @date =  DateTime.now.new_offset(0) # UTC
    group_chat_id = ENV['GROUP_CHAT_ID']
    queue = Queue.new
    producer = Thread.new do
      loop do
        sleep 60
        alerts = receive()
        messages = [" 🤖 *Ruby on Rails: Security* \n\n"]
        alerts.each do |alert|

          hours_f = ((@date - alert[:pubDate]).to_f*24)
          # notify groups last 1 hours
          if hours_f < 1
            messages << "*#{alert[:title]}* \n Date: #{alert[:pubDate].to_s} #{alert[:author]} \n #{alert[:link]}\n\n";
          end
        end
        queue << messages if messages.size > 1
      end
    end

    Thread.new do
      loop do
          messages = queue.pop
         bot.api.send_message(chat_id: group_chat_id, text: escape(messages.join("\n")), parse_mode: 'Markdown', disable_web_page_preview: true) rescue nil
         break unless producer.alive?
      end
    end

  end

  def self.escape message
    message.gsub("_", "\\_")
    .gsub("[", "\[")
    .gsub("`", "\\`")
  end

end