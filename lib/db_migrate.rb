require "sqlite3"

# Open a database
db = SQLite3::Database.new "./database/guru_ce.db"

# Create a table
rows = db.execute <<-SQL
  create table IF NOT EXISTS companies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name varchar(30),
    url varchar(255),
    gov boolean,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    username varchar(255)
  );
SQL

