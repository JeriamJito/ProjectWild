@tool
extends Node2D

const STATES = Globals.STATES

@export_tool_button("Generate Jump Path") var jump_path_button = jump_path_create
@export_tool_button("Reset Position") var reset_position_button = reset_position

@onready var parent : Actor = get_parent()
@onready var position_timer: Timer = %PositionTimer

func jump_path_create() -> void:
	var draw_points := [global_position]
	parent.change_state.emit(STATES.JUMPING)
	parent.direction = 1.0
	position_timer.start()


func reset_position() -> void:
	parent.global_position = Vector2.ZERO


func _on_position_timer_timeout() -> void:
	if parent.is_on_floor():
		parent.direction = 0.0
	position_timer.start()
