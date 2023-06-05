extends Node

const SAVE_LOCATION = "user://Savegame.json"

var save_data: Dictionary = {}

func _ready():
	save_data = loadData()

func saveData():
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.new().stringify(save_data))
	file.close()

func loadData() -> Dictionary:
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	if file == null:
		save_data = {"player_name": "Unnamed"}
		saveData()
	file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.new().parse_string(content)
	save_data = data
	file.close()
	return data
