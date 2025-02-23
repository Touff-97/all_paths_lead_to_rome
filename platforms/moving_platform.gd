@tool
extends CharacterBody3D

@onready var start: Marker3D = $"../Start"
@onready var end: Marker3D = $"../End"

@export var move_speed: float = 2.0  # The speed of platform movement

@export var is_moving: bool = false  # Whether the platform should be moving
@export var wait_time: float = 2.0  # Independent wait time for each platform

var platform_velocity: Vector3 = Vector3.ZERO  # Tracks the platform's velocity
var reached_end: bool = false  # To track whether the platform has reached its destination
var is_waiting: bool = false  # Whether the platform is currently waiting


func _ready():
	# Initialize the platform movement at start position
	transform.origin = start.transform.origin
	_start_wait_timer()


func _process(delta: float) -> void:
	if is_moving:
		# Only move if the platform is moving and not in the waiting state
		if not is_waiting:
			# Calculate the direction to move the platform towards the target position
			var target_position = end.transform.origin if not reached_end else start.transform.origin
			var direction = (target_position - transform.origin).normalized()
			
			transform.origin += direction * move_speed * GameManager.map_speed * delta
			
			# Check if the platform reached its target position (end_position or start_position)
			if transform.origin.distance_to(target_position) < 0.1:
				# Platform reached the target position, stop and wait
				reached_end = not reached_end  # Reverse the state of reached_end
				_start_wait_timer()  # Start waiting at the current target position
		
		# If the character is standing on the platform, make sure it moves with it
		# Character's position should be updated based on platform's position
		if is_on_floor():
			position = transform.origin  # Move character to the platform's position


func _start_wait_timer():
	# Create a new timer dynamically
	var wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.one_shot = true
	wait_timer.wait_time = wait_time / GameManager.map_speed # Set the wait time for this platform
	wait_timer.connect("timeout", Callable(self, "_on_wait_timer_timeout").bind(wait_timer))  # Dynamically bind timeout signal
	wait_timer.start()
	
	is_waiting = true  # Set the platform to the waiting state


func _on_wait_timer_timeout(wait_timer: Timer):
	# Allow movement again after the wait time
	is_waiting = false
	
	wait_timer.queue_free()
