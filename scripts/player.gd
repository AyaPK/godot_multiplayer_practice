extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_force : float = 300.0  
@export var gravity : float = 800.0
@export var friction : float = 1500.0  
@export var acceleration : float = 1000.0  

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		
		sprite.flip_h = direction > 0

	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

	move_and_slide()

	if is_on_floor():
		if direction != 0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	elif velocity.y < 0:
		animation_player.play("jump")
