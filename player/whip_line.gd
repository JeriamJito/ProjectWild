extends Node2D
class_name Rope

@onready var attachment_point: StaticBody2D = %AttachmentPoint
@onready var player_point: RigidBody2D = %PlayerPoint

func create_rope(start: Vector2, end: Vector2) -> void:
	global_position = start
	player_point.global_position = end
	var pinjoint := PinJoint2D.new()
	pinjoint.node_a = attachment_point.get_path()
	pinjoint.node_b = player_point.get_path()
	add_child(pinjoint)
	var player : Actor = get_tree().get_first_node_in_group("Player")
	player.reparent(player_point)
