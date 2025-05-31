extends Node2D
class_name Whip

@export var max_distance := 500

signal set_grapple_point

var _in_use := false

func _process(delta: float) -> void:
	var grapple_point = get_valid_grapple_point()
	set_grapple_point.emit(grapple_point.x)
	if grapple_point.x == -1:
		return
	

func get_valid_grapple_point() -> Vector2:
	var grapple_points : Array = get_tree().get_nodes_in_group("WhipTarget")
	var grapple_point := Vector2(-1, 999999) # x = index, y = distance
	var mouse_position := get_global_mouse_position()
	
	for i in range(grapple_points.size()):
		var test_point : Node2D = grapple_points[i]
		var player_distance = global_position.distance_to(test_point.global_position)
		var mouse_distance = mouse_position.distance_to(test_point.global_position)
		if player_distance <= max_distance and mouse_distance < grapple_point.y:
			grapple_point = Vector2(i, mouse_distance)
	return grapple_point
