require "sqlite3"

# Open a database
db = SQLite3::Database.new "database/guru_ce.db"

class DbConfig

  def self.db
    @db = SQLite3::Database.new "guru_ce.db"
  end
end