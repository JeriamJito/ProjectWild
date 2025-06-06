extends Node2D
class_name World

var state := Globals.WORLD_STATES.RUNNING

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		MenuMusic.play()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
