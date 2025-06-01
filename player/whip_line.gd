extends Node2D
class_name Rope

@export var initial_force := 800

@onready var attachment_point: StaticBody2D = %AttachmentPoint
@onready var player_point: RigidBody2D = %PlayerPoint

func create_rope(start: Vector2, end: Vector2) -> void:
	global_position = start
	player_point.global_position = end
	
	create_pinjoint()
	
	attach_player()
	
	remove_last_whip()


func create_pinjoint() -> void:
	var pinjoint := PinJoint2D.new()
	pinjoint.node_a = attachment_point.get_path()
	pinjoint.node_b = player_point.get_path()
	add_child(pinjoint)


func attach_player() -> void:
	var player : Actor = get_tree().get_first_node_in_group("Player")
	player.reparent(player_point)
	player.velocity = Vector2.ZERO
	var whip_vector := attachment_point.position - player_point.position
	var force_vector := Vector2(-whip_vector.y, whip_vector.x).normalized()
	if player.last_direction == -1:
		force_vector *= Vector2(-1, -1)
	player_point.apply_impulse(force_vector * initial_force)


func remove_last_whip() -> void:
	if get_tree().get_node_count_in_group("WhipLine") > 1:
		var existing_rope = get_tree().get_first_node_in_group("WhipLine")
		existing_rope.queue_free()
