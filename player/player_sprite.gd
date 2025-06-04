extends AnimatedSprite2D

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

func _physics_process(_delta: float) -> void:
	play(STATES.keys()[parent.state])
		
	if flip_h and parent.direction < 0.0 or not flip_h and parent.direction > 0.0:
		flip_h = !flip_h
	
