extends Timer
class_name ClimbingTimer

@export var spam_grace_period := 0.2

func is_grace_over() -> bool:
	return wait_time - time_left >= spam_grace_period
