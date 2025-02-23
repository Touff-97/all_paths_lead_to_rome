extends Control

@export var main : Node3D

@onready var play_sign: MeshInstance2D = $VBox/HBox/PlaySign

signal stopped_play


func _on_main_menu_button_pressed() -> void:
	emit_signal("stopped_play")
	var err = get_tree().change_scene_to_file("res://menus/main_menu.tscn")
	print(err)


func _on_main_menu_button_mouse_entered() -> void:
	play_sign.position.y = 81 - 10


func _on_main_menu_button_mouse_exited() -> void:
	play_sign.position.y = 81
