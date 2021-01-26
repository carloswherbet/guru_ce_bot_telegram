require 'telegram/bot'
require_relative 'db_config.rb'
require 'net/http'
require 'json'
require 'pry'

class Company < DbConfig
  attr_accessor :id, :name, :url, :gov, :username

  def initialize args
    @id = args[:id]
    @name = args[:name]
    @url = args[:url]
    @gov = 'false'
    @username = args[:username]
  end

  def self.all
    @values = []
    db.execute( "select * from companies" ) do |row|
      @values << self.new({id: row[0], name: row[1], url: row[2], gov: row[3], username: row[4] })
    end
    @values

  end

  def create
    DbConfig.db.execute("INSERT INTO companies ( name, url, gov, username)
    VALUES ( ?, ?, ?, ?)", [@name, @url, @gov.to_s, @username ])
    self
  end

  def to_s
    url_description = @url ? "\n  \xF0\x9F\x94\x97 #{@url}" : ""
    "\xF0\x9F\x94\xB7 #{@id} #{@name} #{url_description}"
  end

end