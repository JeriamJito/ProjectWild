extends RayCast2D

@onready var parent : Actor = get_parent()

var _lateral_tp : float

func _ready() -> void:
	_lateral_tp = target_position.x

func _physics_process(_delta: float) -> void:
	target_position.x = _lateral_tp * parent.last_direction
