require "sqlite3"

class DbConfig

  def self.db
    db = SQLite3::Database.new "./database/guru_ce.db"
  end
end