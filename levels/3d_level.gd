@tool
extends Node3D

const MAP_WIDTH: float = 16.0
const MAP_HEIGHT: float = 9.0

@export var background: StaticBody3D
@export var camera: Camera3D
@export var death_area: Area3D

@export var map_depth: float = 50.0
@export var start_moving : bool = false

@onready var end_floor: StaticBody3D = $Objects/EndFloor

var cam_min_depth : float = 9.0
var cam_max_depth : float

signal level_changed(level)
signal game_over


func _ready() -> void:
	print(name + " started!")
	
	end_floor.position.z = -map_depth
	
	for door in get_tree().get_nodes_in_group("level_door"):
		door.new_level_reached.connect(_on_level_door_reached)
		door.position.z = -map_depth - 2


func _process(delta: float) -> void:
	for door in get_tree().get_nodes_in_group("level_door"):
		door.position.z = -map_depth
	
	var death_area_shape = death_area.get_node("Shape")
	death_area_shape.size.x = MAP_WIDTH
	death_area_shape.size.y = MAP_HEIGHT
	death_area_shape.size.z = -map_depth

	death_area_shape.position.z = -map_depth / 2
	cam_max_depth = map_depth - cam_min_depth
	
	if start_moving:
		if GameManager.map_speed > 0.0:
			background.position.z -= GameManager.map_speed * delta
			background.position.z = clamp(background.position.z, -cam_max_depth, cam_max_depth)
			if background.position.z == -cam_max_depth:
				print("reached end")
				death_area.position.y += (GameManager.map_speed / 2) * delta
				death_area.position.y = clamp(death_area.position.y, -5.5, MAP_HEIGHT)

func _on_death_area_body_entered(body: Node3D) -> void:
	if body is Player:
		print("Player entered death area")
		emit_signal("game_over")


func _on_start_moving_area_body_entered(body: Node3D) -> void:
	if body is Player :
		print("Player trigger start of death race")
		start_moving = true


func _on_level_door_reached(level: String) -> void:
	emit_signal("level_changed", level)
