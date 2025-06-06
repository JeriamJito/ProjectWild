extends Button


func _on_pressed() -> void:
	MenuMusic.stop()
	get_tree().change_scene_to_file("res://stage.tscn")
