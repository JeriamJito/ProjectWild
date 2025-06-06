extends Node2D

@onready var color_rect: Sprite2D = %ColorRect

var attach_index := -1:
	set(new_index):
		attach_index = new_index
		color_rect.visible = attach_index > -1


func _process(_delta: float) -> void:
	if attach_index == -1:
		return
	var grapple_points = get_tree().get_nodes_in_group("WhipTarget")
	var grapple_point : Node2D = grapple_points[attach_index]
	global_position = grapple_point.global_position


func _on_whip_set_grapple_point(new_index: int) -> void:
	if attach_index == new_index:
		return
	attach_index = new_index
