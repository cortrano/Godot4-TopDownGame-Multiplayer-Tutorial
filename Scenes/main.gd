extends Control

##____CHOOSE SERVER OR CLIENT____
func _on_server_button_pressed():
	ClientServer.start_server()

func _on_client_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
