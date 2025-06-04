@tool
extends CharacterBody2D
class_name Actor

const STATES = Globals.STATES

@export_enum("Paused:1", "Unpaused:0") var physics : int = 1

signal change_state
signal attempt_change_state
signal velocity_change

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var front_ray_cast: RayCast2D = %FrontRayCast
@onready var top_ray_cast: RayCast2D = %TopRayCast
@onready var coyote_time: Timer = %CoyoteTime
@onready var climbing_timeout: ClimbingTimer = %ClimbingTimeout
@onready var jump_timer: Timer = %JumpTimer
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

var state := STATES.FALLING
var direction := 0.0
var last_direction := 1


func _physics_process(_delta : float) -> void:
	if Engine.is_editor_hint() and physics == 1:
		return
	
	move_and_slide()
	
	global_rotation = 0.0
	direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0.0:
		last_direction = sign(direction)
	
	if direction == 0.0 and is_on_floor():
		change_state.emit(STATES.IDLE)
	
	elif is_on_floor():
		change_state.emit(STATES.WALKING)
		
	if state in [STATES.JUMPING, STATES.FALLING] and \
			can_ledge_grab() and climbing_timeout.is_stopped():
		climbing_timeout.start()
		change_state.emit(STATES.CLIMBING)
	elif state in [STATES.JUMPING, STATES.FALLING, STATES.SWINGING] and \
			Input.is_action_just_pressed("whip_use"):
		attempt_change_state.emit(STATES.SWINGING)
	
	if Input.is_action_just_pressed("jump"):
		if state in [STATES.IDLE, STATES.WALKING, STATES.COYOTE]:
			change_state.emit(STATES.JUMPING)
			jump_timer.start()
		elif state in [STATES.SWINGING]:
			change_state.emit(STATES.JUMPING)
		
	if not Input.is_action_pressed("jump") and \
			state == STATES.JUMPING and jump_timer.is_stopped():
		velocity.y = 0.0
		
	if state == STATES.CLIMBING:
		if climbing_timeout.is_stopped() or Input.is_action_just_pressed("drop_down"):
			climbing_timeout.start()
			change_state.emit(STATES.FALLING)
		elif Input.is_action_just_pressed("jump"):
			climb_up()
			
	if state in [STATES.IDLE, STATES.WALKING] and not climbing_timeout.is_stopped():
		climbing_timeout.stop()
		
	coyote_check()
	
	velocity_change.emit(velocity)


func can_ledge_grab() -> bool:
	if not front_ray_cast.is_colliding():
		return false
	var location = front_ray_cast.get_collision_point().x + 5.0 * last_direction
	top_ray_cast.global_position.x = location
	if not top_ray_cast.is_colliding() or top_ray_cast.get_collision_normal() == Vector2.ZERO:
		return false
	return true


func coyote_check() -> void:
	if not coyote_time.is_stopped() or \
	get_real_velocity().y < 0.0 or \
	is_on_floor() or \
	state in [STATES.CLIMBING, STATES.SWINGING]:
		return
	
	if state in [STATES.WALKING, STATES.SPRINTING]:
		change_state.emit(STATES.COYOTE)
		coyote_time.start()
		return
	
	change_state.emit(STATES.FALLING)


func climb_up() -> void:
	var location = top_ray_cast.get_collision_point()
	var shape : CapsuleShape2D = collision_shape_2d.shape
	location.y -= shape.height * 0.5
	global_position = location
