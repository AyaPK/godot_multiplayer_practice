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

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  
@onready var input: InputSync = $InputSync

func _physics_process(delta):
	if multiplayer.is_server():
		if not is_on_floor():
			velocity.y += gravity * delta
		var direction = input.move_input
		if direction != 0:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
			sprite.flip_h = direction > 0
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		if input.jump_input and is_on_floor():
			velocity.y = -jump_force
		move_and_slide()

		if is_on_floor():
			if direction != 0:
				animation_player.play("walk")
			else:
				animation_player.play("idle")
		elif velocity.y < 0:
			animation_player.play("jump")
