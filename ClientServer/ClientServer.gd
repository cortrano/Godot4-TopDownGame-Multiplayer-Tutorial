extends Node

const DEFAULT_IP = "localhost"
const DEFAULT_PORT = 9999
const MAX_PLAYERS = 4

var multiplayer_peer = ENetMultiplayerPeer.new()
var selected_IP
var selected_port

var local_player_id = 0

var players = {}
var player_data = {}

##____SIGNALS____
func _player_connected(peer_id):
	print("Player: %s Connected" % str(peer_id))
	
	
func _player_disconnected(peer_id):
	print("Player: %s Disconnected" % str(peer_id))
	
func _connected_to_server():
	print("Successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
#	send_player_info.rpc_id(1, local_player_id, player_data)

func _connection_failed():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server disconnected")

#____CLIENT METHODS____
func connect_to_server():
	multiplayer_peer.create_client(selected_IP, selected_port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.server_disconnected.connect(_server_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)

func register_player():
	local_player_id = multiplayer.get_unique_id()
	player_data = SaveSystem.save_data
	players[local_player_id] = player_data

@rpc("any_peer")
func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)

#____SERVER METHODS____
func start_server():
	multiplayer_peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	print("Server started")

@rpc("any_peer", "call_remote", "reliable", 1)
func send_player_info(id, player_data):
	players[id] = player_data
	update_players.rpc(players)
	rpc("update_waiting_room")
	
@rpc("any_peer")
func update_players(playerss):
	players = playerss
