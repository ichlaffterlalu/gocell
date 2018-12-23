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
	query += "sprite_address text NOT NULL,";
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
	query += "character_id int DEFAULT 1 NOT NULL,";
	query += "PRIMARY KEY (name),";
	query += "CONSTRAINT FK_Character FOREIGN KEY (character_id) REFERENCES Characters(id) ON DELETE SET DEFAULT";
	query += ");";
	result = db.query(query);

	# Create records table
	query = "CREATE TABLE Records (";
	query += "user_name char(50) NOT NULL,";
	query += "timestamp datetime NOT NULL,";
	query += "duration double NOT NULL,";
	query += "multiplayer boolean NOT NULL,";
	query += "map_name char(200) NOT NULL,";
	query += "CONSTRAINT FK_User FOREIGN KEY (user_name) REFERENCES Users(name) ON DELETE CASCADE,";
	query += "PRIMARY KEY (user_name, timestamp)";
	query += ");";
	result = db.query(query);

func _init_characters(db):
	var query = "INSERT INTO Characters(id, name, sprite_address, texture_address, stamina, top_speed, acceleration) VALUES ";
	query += "(1, 'Red Blood Cell', 'res://Gameplay/Scenes/Elements/Sprite_Cell_Red.tscn', ";
	query += "'res://Gameplay/Assets/cell-red/cell-red-idle-0.png', 5, 200, 12.5), ";
	query += "(2, 'White Blood Cell', 'res://Gameplay/Scenes/Elements/Sprite_Cell_White.tscn', ";
	query += "'res://Gameplay/Assets/cell-white/cell-white-idle-0.png', 7, 200, 10);";
	return db.query(query);

func close():
	# Close database
	db.close();

func insert_to_records(player_node, multiplayer, map_name):
	var timestamp = OS.get_datetime()
	var query = "INSERT INTO Records (user_name, timestamp, duration, multiplayer, map_name) VALUES ("
	query += "'" + player_node.player_name + "', "
	query += "'%04d-%02d-%02d %02d:%02d:%02d', " % [timestamp.year, timestamp.month, timestamp.day, timestamp.hour, timestamp.minute, timestamp.second]
	query += str(player_node.finish_time/1000.0) + ", "
	query += str(multiplayer) + ", "
	query += "'" + map_name + "');"
	var result = db.query(query)
	return result

func get_records_best_10(user_name="", multiplayer=-1, map_name="", pick_one=false):
	var query = "SELECT * FROM Records "
	var filter = []
	if user_name != "":
		filter.append("user_name = '" + user_name + "'")
	if multiplayer > -1:
		filter.append("multiplayer = " + str(multiplayer))
	if map_name != "":
		filter.append("map_name = '" + str(map_name) + "'")
	if len(filter) > 1:
		query += "WHERE " + filter[0]
		for i in range(1, len(filter)):
			query += " AND " + filter[i]
		query += " "
	elif len(filter) == 1:
		query += "WHERE " + filter[0] + " "
	query += "ORDER BY duration ASC "
	if pick_one:
		query += "LIMIT 1;"
	else:
		query += "LIMIT 10;"
	print(query)
	var result = db.fetch_array(query)
	return result

func get_records_player_best_10(multiplayer=-1, map_name="", pick_one=false):
	var query = "SELECT user_name, timestamp, duration FROM Records "
	var filter = []
	if multiplayer > -1:
		filter.append("multiplayer = " + str(multiplayer))
	if map_name != "":
		filter.append("map_name = '" + str(map_name) + "'")
	if len(filter) > 1:
		query += "WHERE " + filter[0]
		for i in range(1, len(filter)):
			query += " AND " + filter[i]
		query += " "
	elif len(filter) == 1:
		query += "WHERE " + filter[0] + " "
	query += "GROUP BY user_name "
	query += "ORDER BY duration ASC "
	if pick_one:
		query += "LIMIT 1;"
	else:
		query += "LIMIT 10;"
	var result = db.fetch_array(query)
	return result

func list_characters():
	var query = "SELECT * FROM Characters;"
	var result = db.fetch_array(query)
	return result

func get_character_by_id(id):
	var query = "SELECT * FROM Characters "
	query += "WHERE id = " + str(id) + ";"
	var result = db.fetch_array(query)
	return result

func insert_to_users(name, character_id):
	var query = "INSERT OR REPLACE INTO Users (name, character_id) VALUES ("
	query += "'" + name + "', "
	query += str(character_id) + ");"
	var result = db.query(query)
	return result

func get_user_by_name(name):
	var query = "SELECT * FROM Users "
	query += "WHERE name = " + name + ";"
	var result = db.fetch_array(query)
	return result

func reset_leaderboards():
	var query = "DELETE FROM Records;"
	var result = db.query(query)
	return result

func reset_game_data():
	var result = []
	var query = "DELETE FROM Records;"
	result.append(db.query(query))
	query = "DELETE FROM Users;"
	result.append(db.query(query))
	return result