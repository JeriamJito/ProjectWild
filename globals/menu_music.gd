extends AudioStreamPlayer

const PROJECT_WILD_MAIN_MENU_THEME_2 = preload("res://music/Project Wild MainMenu theme2.mp3")

func _ready() -> void:
	stream = PROJECT_WILD_MAIN_MENU_THEME_2
	volume_db = -6.0
	play()
