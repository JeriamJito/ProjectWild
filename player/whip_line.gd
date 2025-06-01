extends Node2D
class_name Rope

@export var initial_force := 800

@onready var attachment_point: StaticBody2D = %AttachmentPoint
@onready var player_point: RigidBody2D = %PlayerPoint

func create_rope(start: Vector2, end: Vector2) -> void:
	var player : Actor = get_tree().get_first_node_in_group("Player")
	global_position = start
	player_point.global_position = end
	var pinjoint := PinJoint2D.new()
	pinjoint.node_a = attachment_point.get_path()
	pinjoint.node_b = player_point.get_path()
	add_child(pinjoint)
	player.reparent(player_point)
	player_point.apply_impulse(Vector2(initial_force * player.last_direction, 0))
	
	if get_tree().get_node_count_in_group("WhipLine") > 1:
		var existing_rope = get_tree().get_first_node_in_group("WhipLine")
		existing_rope.queue_free()
