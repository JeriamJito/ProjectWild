extends Node2D
class_name Gravity

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

# Making a Jump You Can Actually Use In Godot by Pefeper - https://youtu.be/IOe1aGY6hXA
@export var jump_height := 300.0:
	set(new_height):
		jump_height = new_height
		calculate_jump_values()

@export var jump_time_to_peak := 0.3:
	set(new_jump_peak):
		jump_time_to_peak = new_jump_peak
		calculate_jump_values()

@export var jump_time_to_floor := 0.2:
	set(new_jump_floor):
		jump_time_to_floor = new_jump_floor
		calculate_jump_values()

var _jump_velocity : float
var _jump_gravity : float
var _fall_gravity : float

func _ready() -> void:
	parent.change_state.connect(_on_change_state)
	calculate_jump_values()


func calculate_jump_values() -> void:
	_jump_velocity = -2.0 * jump_height / jump_time_to_peak
	_jump_gravity = 2.0 * jump_height / pow(jump_time_to_peak, 2)
	_fall_gravity = jump_height / pow(jump_time_to_floor, 2)


func _physics_process(_delta : float) -> void:
	move_vertical()
	parent.move_and_slide()


func move_vertical() -> void:
	parent.velocity.y += get_calculated_gravity() * get_physics_process_delta_time()


func get_calculated_gravity() -> float:
	return _jump_gravity if parent.state != STATES.FALLING else _fall_gravity


func _on_change_state(state: Globals.STATES) -> void:
	if state != STATES.JUMPING:
		return
	parent.velocity.y = _jump_velocity
