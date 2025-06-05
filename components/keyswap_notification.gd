extends AnimatedSprite2D

const STATES = Globals.STATES

@onready var timeout: Timer = %Timeout

func _ready() -> void:
	var keybind_shuffler_nodes := get_tree().get_nodes_in_group("KeybindShuffler")
	
	for i in range(keybind_shuffler_nodes.size()):
		var keybind_shuffler : Area2D = keybind_shuffler_nodes[i]
		keybind_shuffler.body_entered.connect(show_notification)
		keybind_shuffler.body_exited.connect(show_notification)


func _process(_delta: float) -> void:
	if not is_playing():
		return
	
	if frame == 5:
		pause()
		timeout.start()


func show_notification(body: Node2D) -> void:
	if body.state in [STATES.JUMPING, STATES.SWINGING]:
		return
	
	timeout.stop()
	stop()
	play("default")


func _on_timeout_timeout() -> void:
	frame = 0
