extends CharacterBody2D
class_name Actor

const STATES = Globals.STATES

signal change_state
signal velocity_change

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var front_ray_cast: RayCast2D = %FrontRayCast
@onready var top_ray_cast: RayCast2D = %TopRayCast
@onready var coyote_time: Timer = %CoyoteTime

var state := STATES.IDLE
var direction := 0.0

func _physics_process(_delta : float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0.0:
		scale.x = scale.y * sign(direction)
	
	if direction == 0.0 and is_on_floor():
		change_state.emit(STATES.IDLE)
	
	elif is_on_floor():
		change_state.emit(STATES.WALKING)
	
	if Input.is_action_just_pressed("jump") and \
			state in [STATES.JUMPING, STATES.FALLING] and can_ledge_grab():
		change_state.emit(STATES.CLIMBING)
		var location = top_ray_cast.get_collision_point()
		var shape : CapsuleShape2D = collision_shape_2d.shape
		location.y -= shape.height * 0.5
		global_position = location
	
	if Input.is_action_just_pressed("jump") and \
			state in [STATES.IDLE, STATES.WALKING, STATES.COYOTE]:
		change_state.emit(STATES.JUMPING)
		
	if Input.is_action_just_released("jump") and state == STATES.JUMPING:
		velocity.y = 0.0
		
	coyote_check()
	
	move_and_slide()
	
	velocity_change.emit(velocity)


func can_ledge_grab() -> bool:
	if not front_ray_cast.is_colliding():
		return false
	var location = front_ray_cast.get_collision_point().x + 5.0 * sign(scale.y)
	top_ray_cast.global_position.x = location
	if not top_ray_cast.is_colliding():
		return false
	return true


func coyote_check() -> void:
	if not coyote_time.is_stopped() or get_real_velocity().y < 0.0 or is_on_floor():
		return
	
	if state in [STATES.WALKING, STATES.SPRINTING]:
		change_state.emit(STATES.COYOTE)
		coyote_time.start()
		return
	
	change_state.emit(STATES.FALLING)
