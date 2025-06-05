extends Node2D
class_name Rope

const STATES = Globals.STATES

@export var initial_force := 800
@export var swing_force := 800

@onready var attachment_point: StaticBody2D = %AttachmentPoint
@onready var player_point: RigidBody2D = %PlayerPoint
@onready var pin_joint_2d: PinJoint2D = %PinJoint2D
@onready var player : Actor = get_tree().get_first_node_in_group("Player")
@onready var vine_line: Line2D = %VineLine
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

func _physics_process(_delta: float) -> void:
	if player.state != STATES.SWINGING:
		return
	
	player.rotation = player_point.rotation
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction == 0.0:
		return
	
	var lateral_movement : int = sign(player_point.global_position.x - attachment_point.global_position.x)
	var movement_vector = Vector2(direction, -direction * lateral_movement)
	player_point.apply_force(movement_vector * swing_force)


func create_rope(start: Vector2, end: Vector2, length: float) -> void:
	global_position = start
	player_point.position = Vector2(0.0, length)
	
	create_pinjoint()
	
	player_point.global_position = end
	
	attach_player()
	
	remove_last_whip()


func create_pinjoint() -> void:
	pin_joint_2d.node_b = player_point.get_path()


func attach_player() -> void:
	player.global_position = player_point.global_position
	remote_transform_2d.remote_path = player.get_path()
	var cached_velocity = player.velocity.y
	player.velocity = Vector2.ZERO
	var whip_vector := player_point.position - attachment_point.position
	whip_vector = whip_vector.normalized()
	var force_vector := Vector2(-whip_vector.y, whip_vector.x)
	var applied_force : float = max(initial_force, cached_velocity)
	player_point.apply_impulse(
		force_vector * -player.last_direction * applied_force)


func remove_last_whip() -> void:
	if get_tree().get_node_count_in_group("WhipLine") > 1:
		var existing_rope = get_tree().get_first_node_in_group("WhipLine")
		existing_rope.queue_free()
