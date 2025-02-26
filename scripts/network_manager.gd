extends Node

const PLAYER = preload("res://scenes/player.tscn")
const SPAWN_MIN_X: float = -230.0
const SPAWN_MAX_X: float = 230.0

const MAX_CONNECTIONS = 3
@onready var ip: LineEdit = $NetworkUIPanel/VBoxContainer/IP
@onready var port: LineEdit = $NetworkUIPanel/VBoxContainer/Port
@onready var username: LineEdit = $NetworkUIPanel/VBoxContainer/Username
@onready var network_ui_panel: Panel = $NetworkUIPanel
@onready var spawned_players: Node2D = $SpawnedPlayers

var colour_index: Array = ["red", "blue", "green", "yellow"]

var local_username: String

func _ready() -> void:
	pass
	
func start_host() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port.text), MAX_CONNECTIONS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	_player_connected(multiplayer.get_unique_id())
	
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
	var player: PlayerCharacter = PLAYER.instantiate()
	player.position = Vector2(randf_range(SPAWN_MIN_X, SPAWN_MAX_X), -20)
	player.name = str(player_id)
	player.player_id = player_id
	player.colour_name = colour_index[spawned_players.get_children().size()]
	spawned_players.add_child(player, true)

func _player_disconnected(player_id: int) -> void:
	print("Player %s has left the game" % player_id)
	if not spawned_players.has_node(str(player_id)):
		return
	spawned_players.get_node(str(player_id)).queue_free()

func _connected_to_server() -> void:
	print("Connected to server")
	_hide_network_ui()

func _connection_failed() -> void:
	print("Failed to connect")

func _server_disconnected() -> void:
	print("Disconnected from server")

func _hide_network_ui() -> void:
	network_ui_panel.hide()

func _show_network_ui() -> void:
	network_ui_panel.show()
