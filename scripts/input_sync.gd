class_name InputSync extends MultiplayerSynchronizer

@export var move_input: float
@export var jump_input: bool

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	move_input = Input.get_axis("ui_left", "ui_right")
	jump_input = Input.is_action_pressed("ui_accept")
