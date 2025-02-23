extends CharacterBody3D
class_name Player

const SPEED = 5.0

@export_range(0.0, 32.0, 0.5) var jump_height : float = 10.0
@export_range(0.0, 10.0, 0.1) var jump_time_to_peak : float = 2.0
@export_range(0.0, 5.0, 0.1) var jump_time_to_descent : float = 0.8

@export_enum("2D", "3D") var movement_type : String = "2D"

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var body_pivot: Node3D = $BodyPivot
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_jump_timer: Timer = $BufferJumpTimer

var can_jump : bool = true
var jump_buffered : bool = false


func _physics_process(delta: float) -> void:
	#print("Jump velocity:", jump_velocity)
	#print("Jump gravity:", jump_gravity)
	#print("Fall gravity:", fall_gravity)
	# Add the gravity.
	velocity.y += get_custom_gravity() * delta
	
	# Make sure jump animation doesn't trigger twice
	if not is_on_floor():
		animation_tree.set("parameters/conditions/jump", false)
	
	# Trigger animation for landing as soon as the character is on the floor
	animation_tree.set("parameters/conditions/land", is_on_floor())
	
	# Toggle can_jump if applicable
	if not can_jump and is_on_floor():
		can_jump = true
	
	# Jump if buffered a jump
	if jump_buffered and is_on_floor():
		animation_tree.set("parameters/conditions/jump", true)
		jump()
		print("Jump buffered succesfully")
	
	if not is_on_floor():
		# Check if coyote timer starts
		if can_jump and coyote_timer.is_stopped():
			coyote_timer.start()
		# Check if buffer jump timer starts
		if jump_buffered and buffer_jump_timer.is_stopped():
			buffer_jump_timer.start()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if can_jump:
			animation_tree.set("parameters/conditions/jump", true)
			jump()
		if not can_jump and not jump_buffered:
			jump_buffered = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_rotation_y
	if direction:
		if movement_type == "2D":
			animation_tree.set("parameters/conditions/2d", true)
			animation_tree.set("parameters/conditions/3d", false)
			animation_tree.set("parameters/Walk2D/blend_position", Vector2(direction.x, 0))
			target_rotation_y = atan2(-animation_tree.get("parameters/Walk2D/blend_position").x, 0)
			# Smooth transition using lerp_angle
			body_pivot.rotation.y = lerp_angle(body_pivot.rotation.y, target_rotation_y, delta * SPEED * 3)
			velocity.x = direction.x * SPEED
		else:
			animation_tree.set("parameters/conditions/2d", false)
			animation_tree.set("parameters/conditions/3d", true)
			animation_tree.set("parameters/Walk3D/blend_position", Vector2(direction.x, direction.z))
			target_rotation_y = atan2(-animation_tree.get("parameters/Walk3D/blend_position").x, -animation_tree.get("parameters/Walk3D/blend_position").y)
			# Smooth transition using lerp_angle
			body_pivot.rotation.y = lerp_angle(body_pivot.rotation.y, target_rotation_y, delta * SPEED * 3)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		animation_tree.set("parameters/Walk2D/blend_position", lerp(Vector2(direction.x, direction.z), Vector2.ZERO, delta))
		animation_tree.set("parameters/Walk3D/blend_position", lerp(Vector2(direction.x, direction.z), Vector2.ZERO, delta))

		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func jump() -> void:
	velocity.y = jump_velocity
	can_jump = false


func _on_coyote_timer_timeout() -> void:
	can_jump = false


func _on_buffer_jump_timer_timeout() -> void:
	jump_buffered = false
