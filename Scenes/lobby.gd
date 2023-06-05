extends Control

@onready var name_text_box = $VBoxContainer/GridContainer/NameTextBox
@onready var ip_text_box = $VBoxContainer/GridContainer/IPTextBox
@onready var port_text_box = $VBoxContainer/GridContainer/PortTextBox
@onready var waiting_room = $WaitingRoom
@onready var ready_button = $WaitingRoom/VBoxContainer/ReadyButton

func _ready():
	name_text_box.text = SaveSystem.save_data["player_name"]
	ip_text_box.text = ClientServer.DEFAULT_IP
	port_text_box.text = str(ClientServer.DEFAULT_PORT)
	

func _on_join_button_pressed():
	ClientServer.selected_IP = ip_text_box.text
	ClientServer.selected_port = int(port_text_box.text)
	ClientServer.connect_to_server()
	show_waiting_room()

func _on_name_text_box_text_changed(new_text):
	SaveSystem.save_data["player_name"] = name_text_box.text
	SaveSystem.saveData()

func show_waiting_room():
	waiting_room.show()


func _on_ready_button_pressed():
	ready_button.disabled = true
