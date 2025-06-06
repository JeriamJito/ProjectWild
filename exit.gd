extends Area2D

const STATES = Globals.STATES

signal end_game

@onready var scene_transition: CanvasLayer = %SceneTransition

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if overlaps_body(player) and player.state in [STATES.IDLE, STATES.WALKING]:
		var world : World = get_tree().get_first_node_in_group("World")
		world.state = Globals.WORLD_STATES.PAUSED
		end_game.emit()
