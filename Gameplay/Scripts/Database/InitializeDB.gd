extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

func _ready():
	# Create gdsqlite instance
	var db = SQLite.new();
	
	# Open database
	if (!db.open_db("user://data.sqlite3")):
		print("Cannot open database.");
		return;
	
	var query = "";
	var result = null;
	
	# Create characters table
	query = "CREATE TABLE IF NOT EXISTS Characters (";
	query += "id int NOT NULL,";
	query += "name char(200) NOT NULL,";
	query += "texture_address text NOT NULL,";
	query += "PRIMARY KEY (id)";
	query += ");";
	result = db.query(query);
	
	# Create users table
	query = "CREATE TABLE IF NOT EXISTS Users (";
	query += "name char(50) NOT NULL,";
	query += "character_id int NOT NULL,";
	query += "PRIMARY KEY (user_name),";
	query += "CONSTRAINT FK_Character FOREIGN KEY (character_id) REFERENCES Characters(id)";
	query += ");";
	result = db.query(query);
	
	# Create records table
	query = "CREATE TABLE IF NOT EXISTS Records (";
	query += "user_name char(50) NOT NULL,";
	query += "timestamp datetime NOT NULL,";
	query += "duration double NOT NULL,";
	query += "multiplayer boolean NOT NULL,";
	query += "USER FK_Character FOREIGN KEY (character_id) REFERENCES Characters(id)";
	query += "PRIMARY KEY (user_name, timestamp)";
	query += ");";
	result = db.query(query);
	
	# Close database
	db.close();
