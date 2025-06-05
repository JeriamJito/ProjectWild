extends Line2D

func _physics_process(_delta: float) -> void:
	set_point_position(0, get_parent().attachment_point.position)
	set_point_position(1, get_parent().player_point.position)
