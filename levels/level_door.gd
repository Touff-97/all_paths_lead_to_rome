extends Area3D

@export_file() var next_level
@export var can_enter : bool = false
@export var is_instantaneous : bool = false

@onready var label_3d: Label3D = $Label3D

signal new_level_reached(next_level)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter_door"):
		if can_enter:
			enter_door()


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if is_instantaneous:
			enter_door()
		can_enter = true
		if label_3d:
			label_3d.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		can_enter = false
		if label_3d:
			label_3d.visible = false


func enter_door() -> void:
	print("Player reached new level")
	#GameManager.increase_difficulty()
	emit_signal("new_level_reached", next_level)
