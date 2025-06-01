extends Node2D
class_name Whip

@export var max_distance := 500

@onready var parent : Actor = get_parent()

const WHIP_LINE = preload("res://player/whip_line.tscn")
const GRAPPLE_RESET := Vector2(-1, 999999) # x = index, y = distance
const STATES = Globals.STATES

signal set_grapple_point

var grapple_point := GRAPPLE_RESET
var current_grapple_point := -1.0

func _ready() -> void:
	parent.change_state.connect(create_rope)


func _process(_delta: float) -> void:
	var new_grapple_point = get_valid_grapple_point()
	if new_grapple_point.x != grapple_point.x:
		grapple_point = new_grapple_point
		set_grapple_point.emit(grapple_point.x)


func get_valid_grapple_point() -> Vector2:
	var grapple_points : Array = get_tree().get_nodes_in_group("WhipTarget")
	var grapple_test := GRAPPLE_RESET
	var mouse_position := get_global_mouse_position()
	
	for i in range(grapple_points.size()):
		if i == current_grapple_point:
			continue
		
		var test_point : Node2D = grapple_points[i]
		
		var lateral_distance = global_position.x - test_point.global_position.x
		if sign(lateral_distance) == sign(parent.last_direction):
			continue
		
		var player_distance = global_position.distance_to(test_point.global_position)
		var mouse_distance = mouse_position.distance_to(test_point.global_position)
		if player_distance <= max_distance and mouse_distance < grapple_test.y:
			grapple_test = Vector2(i, mouse_distance)
	return grapple_test


func has_grapple_point():
	return grapple_point.x > -1


func create_rope(state: Globals.STATES) -> void:
	if state == STATES.SWINGING:
		var grapple_points : Array = get_tree().get_nodes_in_group("WhipTarget")
		var test_point : Node2D = grapple_points[grapple_point.x]
		current_grapple_point = grapple_point.x
		var rope : Rope = WHIP_LINE.instantiate()
		get_tree().root.add_child(rope)
		rope.create_rope(test_point.global_position, parent.global_position)
	else:
		var existing_rope : Rope = get_tree().get_first_node_in_group("WhipLine")
		if not existing_rope:
			return
		parent.reparent(get_tree().root)
		existing_rope.queue_free()
		current_grapple_point = -1
