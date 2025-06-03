extends AnimatedSprite2D

const STATES = Globals.STATES

@onready var parent : Actor = get_parent()

func _physics_process(delta: float) -> void:
	if parent.state != STATES.WALKING or parent.direction == 0.0:
		stop()
		return
		
	if flip_h and parent.direction < 0.0 or not flip_h and parent.direction > 0.0:
		flip_h = !flip_h
	
	play("walking")
