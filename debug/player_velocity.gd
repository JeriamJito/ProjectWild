extends Label


func _on_player_velocity_change(velocity: Vector2) -> void:
	text = "VELOCITY: " + str(velocity)
