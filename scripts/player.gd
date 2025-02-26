class_name PlayerCharacter extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_force : float = 300.0  
@export var gravity : float = 800.0
@export var friction : float = 1500.0  
@export var acceleration : float = 1000.0  
@export var player_name : String
@export var player_id: int = 1:
	set(id): 
		player_id = id
		$InputSync.set_multiplayer_authority(id)
@export var colour_name: String
@export var animation_name: String
@export var v: Vector2
@export var on_floor: bool

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  
@onready var input: InputSync = $InputSync


const BLUE_GUY = preload("res://sprites/blue_guy.png")
const GREEN_GUY = preload("res://sprites/green_guy.png")
const RED_GUY = preload("res://sprites/red_guy.png")
const YELLOW_GUY = preload("res://sprites/yellow_guy.png")
const colour_dict: Dictionary = {
	"red": RED_GUY,
	"green": GREEN_GUY,
	"blue": BLUE_GUY,
	"yellow": YELLOW_GUY
}

signal walk

func _ready() -> void:
	sprite.texture = colour_dict[colour_name]
	walk.connect(_play_walk)

func _physics_process(delta):
	if multiplayer.is_server():
		_server_movement(delta)
	_client_calcs()

func _play_walk() -> void:
	animation_player.play("walk")

func _server_movement(delta: float) -> void:
	on_floor = is_on_floor()
	if not on_floor:
		velocity.y += gravity * delta
	var direction = input.move_input
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	if input.jump_input and on_floor:
		velocity.y = -jump_force
	v = velocity
	move_and_slide()

func _client_calcs() -> void:
	if on_floor:
		if v != Vector2.ZERO:
			walk.emit()
		else:
			animation_player.play("idle")
	elif v.y < 0:
		animation_player.play("jump")
	sprite.flip_h = v.x > 0
