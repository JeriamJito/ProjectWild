extends Node2D
class_name StateMachine

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

func _ready() -> void:
	parent.change_state.connect(_on_change_state)

var _state := STATES.IDLE:
	set(new_state):
		_state = new_state
		parent.state = _state

func _on_change_state(state: Globals.STATES):
	_state = state
