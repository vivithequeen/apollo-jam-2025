extends CharacterBody3D


const SPEED = 3.5
const JUMP_VELOCITY = 4.5
const LOOKSENSE := (0.0025 /2.0) * 4.0


@onready var anim_tree = $Node3D/AnimationTree
var paused := false

var walk_forwards = 0.0;
var walk_backwards = 0.0;
var walk_right = 0.0;
var walk_left = 0.0;
var run = 0.0
func _ready() -> void:
	update_mouse_mode()

func _physics_process(delta: float) -> void:
	var is_sprint = Input.is_action_pressed("sprint")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * (1.4 if is_sprint else 1.0)
		velocity.z = direction.z * SPEED * (1.4 if is_sprint else 1.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var tween = get_parent().create_tween()
	tween.tween_property(self, "walk_forwards", (1.0 if   input_dir.y > 0 else 0.0), delta*10.0);
	tween.parallel()
	tween.tween_property(self, "walk_backwards", (1.0 if input_dir.y < 0 else 0.0), delta*10.0);
	tween.parallel()
	tween.tween_property(self, "walk_right", (0.75 if     input_dir.x > 0 else 0.0), delta*10.0);
	tween.parallel()
	tween.tween_property(self, "walk_left", (0.75 if     input_dir.x < 0 else 0.0), delta*10.0);
	tween.parallel()
	
	tween.tween_property(self, "run", 1.0 if (is_sprint and input_dir) else 0.0, delta*10.0);

	anim_tree["parameters/walk_forwards/blend_amount"] =  walk_forwards
	anim_tree["parameters/walk_backwards/blend_amount"] = walk_backwards 
	anim_tree["parameters/walk_right/blend_amount"] =  walk_right
	anim_tree["parameters/walk_left/blend_amount"] =  walk_left
	anim_tree["parameters/run/blend_amount"] = run
	



	move_and_slide()


func _process(_delta: float) -> void:
	$head.global_rotation = $ThirdPersonCamera/Camera.global_rotation

	$SubViewport/Camera3D.global_position = $ThirdPersonCamera/Camera.global_position
	$SubViewport/Camera3D.global_rotation = $ThirdPersonCamera/Camera.global_rotation

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y( - event.relative.x * LOOKSENSE)



func update_mouse_mode():
	
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
