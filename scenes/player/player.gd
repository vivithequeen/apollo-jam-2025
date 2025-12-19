extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOKSENSE := (0.0025 /2.0) * 4.0

var paused := false

var idletowalk : float = 0.0;
func _ready() -> void:
	update_mouse_mode()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if (velocity * Vector3(1,0,1) != Vector3.ZERO):
		var tween = get_parent().create_tween()
		tween.tween_property(self, "idletowalk", 1.0, delta);

	$Node3D/AnimationTree.set("parameters/Blend2/blend_amount", idletowalk)
	print($Node3D/AnimationTree.get("parameters/idletoWalk/blend_amount")
)


	move_and_slide()


func _process(delta: float) -> void:
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
