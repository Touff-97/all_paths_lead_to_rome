@tool
extends TextureButton

@onready var label: Label = $Label

@export_file() var level : String
@export var next_level : Array[String] = []
@export_enum("2D", "3D") var level_type : String = "2D"
@export var is_explored : bool = false

signal level_selected(level)


func _process(delta: float) -> void:
	if level_type == "2D":
		set("texture_normal", load("res://assets/menus/Game Jam/door.png"))
		set("texture_hover", load("res://assets/menus/Game Jam/door_open.png"))
		if is_explored:
			set("texture_disabled", load("res://assets/menus/Game Jam/door_open.png"))
		else:
			set("texture_disabled", load("res://assets/menus/Game Jam/door.png"))
		if label:
			label.show()
			label.text = name.split("_")[-1]
	else:
		set("texture_normal", load("res://assets/menus/Game Jam/stone_normal.png"))
		set("texture_hover", load("res://assets/menus/Game Jam/stone_selected.png"))
		if is_explored:
			set("texture_disabled", load("res://assets/menus/Game Jam/stone_selected.png"))
		else:
			set("texture_disabled", load("res://assets/menus/Game Jam/stone_normal.png"))
		if label:
			label.hide()

	if disabled:
		set("modulate", "#ffffffaa")
	else:
		set("modulate", "#ffffff")


func _on_pressed() -> void:
	print("enter level")
	emit_signal("level_selected", level)
