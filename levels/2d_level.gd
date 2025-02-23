@tool
extends Node3D

@export var background: CSGBox3D
@export var camera: Camera3D
@export var death_area: Area3D
@export var lava: CSGBox3D

@export var map_width: float = 16.0
@export var map_height: float = 9.0

@export var start_moving : bool = false
@export var is_botttom_up : bool = true:
	set(new_value):
		is_botttom_up = new_value
		camera.position.y = cam_min_height if new_value else cam_max_height
		death_area.position.y = -5.5 if new_value else 5.5
		lava.position.y = -6.25 if new_value else 6.25

var cam_min_height : float = 4.5
var cam_max_height : float

var death_max_height : float = 5.5

signal level_changed(level)
signal game_over


func _ready() -> void:
	print(name + " started!")
	
	for door in get_tree().get_nodes_in_group("level_door"):
		door.new_level_reached.connect(_on_level_door_reached)


func _process(delta: float) -> void:
	background.size.x = map_width
	background.size.y = map_height
	background.position.y = map_height / 2
	cam_max_height = map_height - cam_min_height
	
	if start_moving:
		if is_botttom_up:
			camera.position.y += GameManager.map_speed * delta
			camera.position.y = clamp(camera.position.y, cam_min_height, cam_max_height)
			if camera.position.y >= cam_max_height:
				death_area.position.y += (GameManager.map_speed / 2) * delta
				death_area.position.y = clamp(death_area.position.y, -5.5, 5.5)
		else:
			if camera.position.y > cam_min_height:
				camera.position.y -= GameManager.map_speed * delta
			else:
				camera.position.y = cam_min_height
				death_area.position.y -= GameManager.map_speed * delta


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
