@tool
extends Node3D

@onready var end: Marker3D = $End
@export var platform: CharacterBody3D

@export var target_direction : Vector3:
	set(new_value):
		target_direction = new_value
		if platform:
			platform.position = Vector3.ZERO
		
@export var is_moving : bool
@export_range(0.0, 10.0, 0.01) var velocity = 1.0
@export_range(0.0, 10.0, 0.5) var wait_time : float = 2.0


func _process(delta: float) -> void:
	end.position = target_direction
	platform.is_moving = is_moving
	platform.move_speed = velocity
	platform.wait_time = wait_time
