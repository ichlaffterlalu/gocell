extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");
# Create gdsqlite instance
var db = SQLite.new();

func _ready():
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

func _init_characters(db):
	var query = "INSERT INTO Characters(id, name, texture_address, stamina, top_speed, acceleration) VALUES ";
	query += "(1, 'Red Blood Cell', 'res://Gameplay/Assets/red cell.png', 5, 200, 12.5), ";
	query += "(2, 'White Blood Cell', 'res://Gameplay/Assets/white cell.png', 7, 200, 10);";
	return db.query(query);

func close():
	# Close database
	db.close();

func insert_to_records(player_node, multiplayer):
	var timestamp = OS.get_datetime()
	var query = "INSERT INTO Records (user_name, timestamp, duration, multiplayer) VALUES ("
	query += "'" + player_node.player_name + "', "
	query += "'%04d-%02d-%02d %02d:%02d:%02d', " % [timestamp.year, timestamp.month, timestamp.day, timestamp.hour, timestamp.minute, timestamp.second]
	query += str(player_node.finish_time/1000) + ", "
	query += str(multiplayer) + ");"
	var result = db.query(query)
	return result

func get_records_best_10(user_name="", multiplayer=-1, pick_one=false):
	var query = "SELECT * FROM Records "
	var filter = ["WHERE"]
	if user_name != "":
		filter.append("user_name = '" + user_name + "'")
	if multiplayer > -1:
		filter.append("multiplayer = " + str(multiplayer))
	if len(filter) > 1:
		query += " ".join(filter) + " "
	query += "SORT BY duration ASC "
	if pick_one:
		query += "LIMIT 1;"
	else:
		query += "LIMIT 10;"
	var result = db.fetch_array(query)
	print(result)
	return result

func list_characters():
	var query = "SELECT * FROM Characters;"
	var result = db.fetch_array(query)
	print(result)
	return result

func get_character_by_id(id):
	var query = "SELECT * FROM Characters "
	query += "WHERE id = " + str(id) + ";"
	var result = db.fetch_array(query)
	print(result)
	return result

func insert_to_users(name, character_id):
	var query = "INSERT INTO Users (user_name, character_id) VALUES ("
	query += "'" + name + "', "
	query += str(character_id) + ");"
	var result = db.query(query)
	print(result)
	return result

func get_user_by_name(name):
	var query = "SELECT * FROM Users "
	query += "WHERE name = " + name + ";"
	var result = db.fetch_array(query)
	print(result)
	return result