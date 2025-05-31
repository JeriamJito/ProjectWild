extends Node2D

@onready var color_rect: ColorRect = %ColorRect

var attach_index := -1:
	set(new_index):
		attach_index = new_index
		color_rect.visible = attach_index > -1
		if not color_rect.visible:
			return
		var grapple_points = get_tree().get_nodes_in_group("WhipTarget")
		var grapple_point : Node2D = grapple_points[attach_index]
		position = grapple_point.global_position


func _on_whip_set_grapple_point(new_index: int) -> void:
	attach_index = new_index
