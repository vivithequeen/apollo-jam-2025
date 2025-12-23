extends CharacterBody3D

@export var movement_speed: float = 2.5
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

@export var player : CharacterBody3D
@export var random_points : Node3D

enum States {
	ROAM,
	INVESTIGATE,
	CHASE,
}
@onready var anim_tree = $Node3D/AnimationTree
var footstep_sounds = [
	preload("res://resources/sounds/monster_footsteps/footstep1.mp3"),
	preload("res://resources/sounds/monster_footsteps/footstep2.mp3"),
	preload("res://resources/sounds/monster_footsteps/footstep3.mp3"),
	preload("res://resources/sounds/monster_footsteps/footstep4.mp3"),
	preload("res://resources/sounds/monster_footsteps/footstep5.mp3"),
]

var yell_sounds = [
	preload("res://resources/sounds/monster_footsteps/igotyou.mp3"),
	preload("res://resources/sounds/monster_footsteps/IHEARTHAT.mp3"),
	preload("res://resources/sounds/monster_footsteps/whereisbro.mp3"),
]
var state : States = States.ROAM


var investigate_timer = 0;
var bordom = 0;
func _ready() -> void:
	if(state == States.ROAM):
		go_to_random_point()
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	print(state)
	if(navigation_agent.get_next_path_position() != global_position):
		look_at(navigation_agent.get_next_path_position(),Vector3.UP)
		rotation*=Vector3(0,1,0)
		rotation.y+=PI
	

	if(state == States.ROAM):
		$footsteps.volume_db = 0.0
		movement_speed =2.5
		$foot.wait_time = 1
		if(navigation_agent.is_navigation_finished()):

			go_to_random_point()
	elif(state == States.INVESTIGATE):
		if(navigation_agent.is_navigation_finished()):
			anim_tree["parameters/idle/blend_amount"] = 1.0
			$footsteps.volume_db = -80.0
			investigate_timer+=delta
			if(investigate_timer > 2.0):
				$footsteps.volume_db = 0.0
				anim_tree["parameters/idle/blend_amount"] = 0.0
				investigate_timer = 0;
				state = States.ROAM
	else:
		$footsteps.volume_db = 0.0
		bordom +=delta
		if(bordom > 3.0):
			state = States.INVESTIGATE
		anim_tree["parameters/idle/blend_amount"] = 0.0
	

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

	state = States.INVESTIGATE
	set_movement_target(location)
	movement_speed =4.0
	$foot.wait_time = 0.66666666666 
	$scream.stream = yell_sounds.pick_random()
	$scream.play()


func _on_foot_timeout():
	$footsteps.stream = footstep_sounds.pick_random()
	$footsteps.pitch_scale = randf_range(0.8,1.2)
	$footsteps.play()

func hear_something_soft(location : Vector3):
	
	if(state == States.ROAM):
		return;
	if((global_position - location).length() > 15.0):
		return
	bordom = 0;
	set_movement_target(location)
	state = States.CHASE
	movement_speed =4.0
	$foot.wait_time = 0.66666666666 


func _on_kill_zone_body_entered(body: Node3D) -> void:
	if(body.name == "player"):
		get_node("../../../../").player_die()
