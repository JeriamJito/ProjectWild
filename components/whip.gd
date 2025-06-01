extends Node2D
class_name Whip

@export var max_distance := 500

@onready var parent : Actor = get_parent()

const WHIP_LINE = preload("res://player/whip_line.tscn")

signal set_grapple_point

var _in_use := false
var grapple_point := Vector2(-1, 999999) # x = index, y = distance

func _process(_delta: float) -> void:
	grapple_point = get_valid_grapple_point()
	set_grapple_point.emit(grapple_point.x)


func _physics_process(_delta: float) -> void:
	if _in_use or not has_grapple_point():
		return
	if Input.is_action_just_pressed("whip_use"):
		var grapple_points : Array = get_tree().get_nodes_in_group("WhipTarget")
		var test_point : Node2D = grapple_points[grapple_point.x]
		var rope := WHIP_LINE.instantiate()
		rope.set_point_position(0, test_point.global_position)
		rope.set_point_position(1, parent.global_position)
		get_tree().root.add_child(rope)

func get_valid_grapple_point() -> Vector2:
	var grapple_points : Array = get_tree().get_nodes_in_group("WhipTarget")
	var mouse_position := get_global_mouse_position()
	
	for i in range(grapple_points.size()):
		var test_point : Node2D = grapple_points[i]
		var player_distance = global_position.distance_to(test_point.global_position)
		var mouse_distance = mouse_position.distance_to(test_point.global_position)
		if player_distance <= max_distance and mouse_distance < grapple_point.y:
			grapple_point = Vector2(i, mouse_distance)
	return grapple_point


func has_grapple_point():
	return grapple_point.x > -1
