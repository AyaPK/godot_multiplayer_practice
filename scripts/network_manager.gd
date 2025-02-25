extends Node

const MAX_CONNECTIONS = 3
@onready var ip: LineEdit = $NetworkUIPanel/VBoxContainer/IP
@onready var port: LineEdit = $NetworkUIPanel/VBoxContainer/Port
@onready var username: LineEdit = $NetworkUIPanel/VBoxContainer/Username
@onready var network_ui_panel: Panel = $NetworkUIPanel

var local_username: String

func _ready() -> void:
	pass
	
func start_host() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port.text), MAX_CONNECTIONS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	
	_hide_network_ui()

func start_client() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip.text, int(port.text))
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)

func _on_username_change(updated_username: String) -> void:
	local_username = updated_username

func _player_connected(player_id: int) -> void:
	print("Player has joined the server with id %s" % player_id)

func _player_disconnected(player_id: int) -> void:
	print("Player %s has left the game" % player_id)

func _connected_to_server() -> void:
	print("Connected to server")
	_hide_network_ui()

func _connection_failed() -> void:
	print("Failed to connect")

func _server_disconnected() -> void:
	print("Disconnected from server")
	_show_network_ui()

func _hide_network_ui() -> void:
	network_ui_panel.hide()

func _show_network_ui() -> void:
	network_ui_panel.show()
