extends CharacterBody3D

@export var movement_speed: float = 2.5
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

@export var player : CharacterBody3D
@export var random_points : Node3D

enum States {
	ROAM,
	CHASE,
}


var state : States = States.ROAM

func _ready() -> void:
	if(state == States.ROAM):
		go_to_random_point()
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	look_at(navigation_agent.get_next_path_position(),Vector3.UP)
	rotation*=Vector3(0,1,0)
	rotation.y+=PI
	if(state == States.ROAM):
		if(navigation_agent.is_navigation_finished()):
			go_to_random_point()
	

	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()



func go_to_random_point():
	var point : Vector3
	point = random_points.get_children().pick_random().global_position
	set_movement_target(point)

func hear_something(location : Vector3) -> void:
	return
	set_movement_target(location)



	
#if(state == States.ROAM):
#	go_to_random_point()
