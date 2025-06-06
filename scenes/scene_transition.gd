extends CanvasLayer

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var color_rect: ColorRect = %ColorRect

func _on_exit_end_game() -> void:
	color_rect.visible = true
	animation_player.play("fade_to_black")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	MenuMusic.play()
