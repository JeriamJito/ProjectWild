extends Label

const STATES = Globals.STATES

func _on_player_change_state(state: Globals.STATES) -> void:
	text = "STATE: " + STATES.keys()[state]
