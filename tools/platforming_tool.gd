@tool
extends Actor

@export_tool_button("Generate Test Actor") var generate_test_actor = test_actor_create
@export_tool_button("Generate Jump Path") var generate_jump_path = draw_trajectory
@export_tool_button("Clear Lines") var clear_line_button = clear_lines
@export_enum("Left:-1", "Right:1") var test_direction : int = 1
@export var character_node : Actor
@export var movement_node : Movement
@export var collision_node : CollisionShape2D

@onready var gravity_node: Gravity = %Gravity
@onready var collision_test: CollisionShape2D = %CollisionShape2D
@onready var execution_timer: Timer = %ExecutionTimer
@onready var point_interval: Timer = %PointInterval

var draw_points : Array

func _ready() -> void:
	if not Engine.is_editor_hint():
		return

	state = STATES.FALLING


func test_actor_create() -> void:
	gravity_node._ready()
	collision_test.shape = collision_node.shape



func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	
	if velocity.y <= 0.0:
		state = STATES.FALLING
	
	velocity.y += gravity_node.get_calculated_gravity() * delta
	
	move_and_slide()


func draw_trajectory() -> void:
	clear_lines()
	
	var origin_position = global_position
	
	execution_timer.start()
	draw_points = []
	
	draw_points.append(global_position)
	state = STATES.JUMPING
	velocity.y = gravity_node._jump_velocity
	velocity.x = test_direction * movement_node.speed
	point_interval.start()


func _on_point_interval_timeout() -> void:
	if is_on_floor():
		velocity.x = 0.0
		draw_points.append(global_position)
		var line = Line2D.new()
		for i in range(draw_points.size()):
			line.add_point(draw_points[i])
		line.add_to_group("Temp")
		get_parent().add_child(line)
		return
	
	draw_points.append(global_position)
	point_interval.start()


func clear_lines() -> void:
	var lines := get_tree().get_nodes_in_group("Temp")
	for i in range (lines.size()):
		lines[i].queue_free()
