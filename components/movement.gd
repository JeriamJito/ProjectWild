@tool
extends Node2D
class_name Movement

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

@export var speed := 1000.0
@export var acceleration := 2000.0

func _physics_process(_delta : float) -> void:
	if parent.state in [STATES.CLIMBING, STATES.SWINGING]:
		return
	move_lateral()


func move_lateral() -> void:
	parent.velocity.x = parent.direction * speed
