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
	query = "CREATE TABLE Characters (";
	query += "id int NOT NULL,";
	query += "name char(200) NOT NULL,";
	query += "texture_address text NOT NULL,";
	query += "stamina int NOT NULL,";
	query += "top_speed real NOT NULL,";
	query += "acceleration real NOT NULL,";
	query += "PRIMARY KEY (id)";
	query += ");";
	result = db.query(query);
	if (result):
		result = _init_characters(db);
	
	# Create users table
	query = "CREATE TABLE Users (";
	query += "name char(50) NOT NULL,";
	query += "character_id int NOT NULL,";
	query += "PRIMARY KEY (name),";
	query += "CONSTRAINT FK_Character FOREIGN KEY (character_id) REFERENCES Characters(id)";
	query += ");";
	result = db.query(query);
	
	# Create records table
	query = "CREATE TABLE Records (";
	query += "user_name char(50) NOT NULL,";
	query += "timestamp datetime NOT NULL,";
	query += "duration double NOT NULL,";
	query += "multiplayer boolean NOT NULL,";
	query += "CONSTRAINT FK_User FOREIGN KEY (user_name) REFERENCES Users(name),";
	query += "PRIMARY KEY (user_name, timestamp)";
	query += ");";
	result = db.query(query);
	
	# Close database
	db.close();

func _init_characters(db):
	var query = "INSERT INTO Characters(id, name, texture_address, stamina, top_speed, acceleration) VALUES ";
	query += "(1, 'Red Blood Cell', 'res://Gameplay/Assets/red cell.png', 5, 200, 12.5);";
	return db.query(query);