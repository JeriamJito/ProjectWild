@tool
extends Node2D

const STATES = Globals.STATES

@export_tool_button("Generate Jump Path") var jump_path_button = jump_path_create
@export_tool_button("Clear Lines") var clear_lines_button = clear_lines
@export_tool_button("Reset Position") var reset_position_button = reset_position
@export_enum("Left:-1", "Right:1") var test_direction : int = -1

@onready var position_timer: Timer = %PositionTimer

var _default_position := Vector2.ZERO
var _draw_points : Array

func jump_path_create() -> void:
	_default_position = global_position
	_draw_points = [global_position]
	get_parent().change_state.emit(STATES.JUMPING)
	get_parent().direction = test_direction
	position_timer.start()


func reset_position() -> void:
	get_parent().global_position = _default_position


func clear_lines() -> void:
	var temp_nodes := get_tree().get_nodes_in_group("Temp")
	for i in range(temp_nodes.size()):
		temp_nodes[i].queue_free()


func _on_position_timer_timeout() -> void:
	_draw_points.append(global_position)
	if get_parent().is_on_floor():
		get_parent().direction = 0.0
		draw_trajectory()
		return
	
	position_timer.start()


func draw_trajectory() -> void:
	var new_line := Line2D.new()
	new_line.add_to_group("Temp")
	for i in range(_draw_points.size()):
		new_line.add_point(_draw_points[i])
	get_tree().edited_scene_root.add_child(new_line)
