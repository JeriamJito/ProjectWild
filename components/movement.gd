extends Node2D
class_name Movement

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

@export var speed := 500.0
@export var acceleration := 2000.0

func _physics_process(_delta : float) -> void:
	if parent.state == STATES.CLIMBING:
		return
	move_lateral()


func move_lateral() -> void:
	if parent.direction == 0.0:
		parent.velocity.x = 0.0
	else:
		parent.velocity.x = move_toward(
			parent.velocity.x,
			parent.direction * speed,
			acceleration * get_physics_process_delta_time())
