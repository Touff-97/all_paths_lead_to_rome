extends Node3D

@onready var current_level: Node3D = $CurrentLevel
@onready var gui: CanvasLayer = $GUI
@onready var hud: MarginContainer = $GUI/HUD
@onready var map: TextureRect = $GUI/Map
@onready var music: AudioStreamPlayer = $Music
@onready var music_death: AudioStreamPlayer = $MusicDeath

signal stopped_play

func _ready() -> void:
	GameManager.connect("player_died", _on_reload_level)
	GameManager.connect("map_speed_changed", _on_map_speed_changed)
	
	map.show()
	
	GameManager.set_difficulty(1.0)
	
	music.pitch_scale = 0.5


func _on_level_game_over() -> void:
	GameManager.increase_difficulty()
	
	music_death.play()
	
	gui.trigger_game_over()


func _on_reload_level() -> void:
	_on_level_changed(GameManager.traversed_levels[-1])


func _on_level_changed(level: Variant) -> void:
	if current_level.get_child_count() > 0:
		current_level.get_child(0).queue_free()
	
	var new_level = load(level).instantiate()
	current_level.add_child(new_level, true)
	
	var new_level_path = new_level.scene_file_path
	GameManager.save_level_as_traversed(new_level_path)
	
	new_level.connect("level_changed", _on_level_changed)
	new_level.connect("game_over", _on_level_game_over)


func _on_pause_menu_stopped_play() -> void:
	emit_signal("stopped_play")


func _on_map_level_selected(level: Variant) -> void:
	print("map hidden")
	map.hide()
	hud.show()


func _on_map_speed_changed(speed: Variant) -> void:
	music.pitch_scale = 1.0 + (speed / 10)
	print("pitch: ", music.pitch_scale)


func _on_game_over_menu_visibility_changed() -> void:
	if not visible:
		print("revived")
		music_death.stop()
		music.stop()
		music.play()


func _on_game_over_menu_hidden() -> void:
	music_death.stop()
	music.stop()
	music.play()
