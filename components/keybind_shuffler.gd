extends Area2D

@export var keyswap : Keyswap

var compiled_actions : Dictionary[String, InputEvent]

func _ready() -> void:
	compile_keybinds()


func compile_keybinds() -> void:
	compiled_actions = {
		"move_left": keyswap.left,
		"move_right": keyswap.right,
		"jump": keyswap.jump,
		"drop_down": keyswap.drop,
		"whip_use": keyswap.whip,
	}


func _on_body_entered(body: Node2D) -> void:
	if get_tree().get_first_node_in_group("Player") != body:
		return
	
	body.keyswap_areas += 1

	for key in compiled_actions:
		if not compiled_actions[key]:
			continue
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key, compiled_actions[key])


func _on_body_exited(body: Node2D) -> void:
	if get_tree().get_first_node_in_group("Player") != body:
		return
	
	body.keyswap_areas -= 1
	if body.keyswap_areas > 0:
		return
	
	InputMap.load_from_project_settings()
