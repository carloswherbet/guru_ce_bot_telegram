require 'telegram/bot'
require_relative 'db_config.rb'
require 'net/http'
require 'json'
require 'pry'

class Company < DbConfig
  ATTRIBUTES = [:id, :name, :url, :gov, :username]
  attr_accessor *ATTRIBUTES


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
      @values << self.new({id: row[0], name: row[1], url: row[2], gov: row[3], username: row[5] })
    end
    @values
  end

  def self.find id
    row = DbConfig.db.execute("select * from  companies where id = ?", [id]).first
    self.new({id: row[0], name: row[1], url: row[2], gov: row[3], username: row[5] })
  end

  def update
    DbConfig.db.execute("UPDATE companies set name = ?, url = ?, gov = ?, username = ?
     WHERE id = ?", [@name, @url, @gov.to_s, @username, @id])
     self
  end

  def destroy
    DbConfig.db.execute("DELETE FROM companies where id = ?", [@id])
  end

  def create
    DbConfig.db.execute("INSERT INTO companies ( name, url, gov, username)
    VALUES ( ?, ?, ?, ?)", [@name, @url, @gov, @username])
    self
  end

  def to_s
    if @url
      "[\xF0\x9F\x94\xB7 #{@id} - #{@name} \xF0\x9F\x94\x97](#{@url})"
    else
      "\xF0\x9F\x94\xB7 #{@id} - #{@name}"
    end
  end

  def attributes
    ATTRIBUTES.map{|attribute| self.send(attribute) }
  end

end