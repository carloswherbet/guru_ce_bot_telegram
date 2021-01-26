require 'telegram/bot'
require 'net/http'
require 'json'
require_relative 'bot.rb'

require "sqlite3"

class Company
  @id = nil
  @name = nil
  @url = nil
  @gov = false

  def initialize args
    @id = args[:id]
    @name = args[:name]
    @url = args[:url]
    @gov = 'false'
    
  end

  def self.db
    SQLite3::Database.new "guru_ce.db"
  end

  def self.all
    @values = []
    db.execute( "select * from companies" ) do |row|
      @values << self.new({id: row[0], name: row[1], url: row[2], gov: row[3] })
    end
    @values

  end

  def create username
    db = SQLite3::Database.new "guru_ce.db"
    db.execute("INSERT INTO companies ( name, url, gov, username) 
    VALUES ( ?, ?, ?, ?)", [@name, @url, @gov.to_s, username ])
    self
  end

  def to_s
    url_description = @url ? "\n  \xF0\x9F\x94\x97 #{@url}" : ""
    "\xF0\x9F\x94\xB7 #{@id} #{@name} #{url_description}"
  end

end