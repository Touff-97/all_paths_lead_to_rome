extends Control

const MAIN := preload("res://main.tscn")

@onready var main_margin: MarginContainer = $MainMargin
@onready var settings_margin: MarginContainer = $SettingsMargin
@onready var credits_margin: MarginContainer = $CreditsMargin

@onready var play_sign: MeshInstance2D = $MainMargin/VBox/HBox/PlaySign
@onready var settings_sign: MeshInstance2D = $MainMargin/VBox/HBox/SettingsSign
@onready var credits_sign: MeshInstance2D = $MainMargin/VBox/HBox/CreditsSign

@onready var play_button: Button = $MainMargin/VBox/HBox/PlayButton
@onready var settings_button: Button = $MainMargin/VBox/HBox/SettingsButton
@onready var credits_button: Button = $MainMargin/VBox/HBox/CreditsButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal started_play


func _ready() -> void:
	print(play_button.is_connected("pressed", _on_play_button_pressed))


func _on_play_button_pressed() -> void:
	print("play")
	audio_stream_player.stop()
	emit_signal("started_play")
	var err = get_tree().change_scene_to_file("res://main.tscn")
	print(err)


func _on_play_button_mouse_entered() -> void:
	play_sign.position.y = 80


func _on_play_button_mouse_exited() -> void:
	play_sign.position.y = 90


func _on_settings_button_pressed() -> void:
	main_margin.hide()
	settings_margin.show()


func _on_settings_button_mouse_entered() -> void:
	settings_sign.position.y = 80


func _on_settings_button_mouse_exited() -> void:
	settings_sign.position.y = 90


func _on_credits_button_pressed() -> void:
	main_margin.hide()
	credits_margin.show()


func _on_credits_button_mouse_entered() -> void:
	credits_sign.position.y = 80


func _on_credits_button_mouse_exited() -> void:
	credits_sign.position.y = 90


func _on_back_button_pressed() -> void:
	main_margin.show()
	settings_margin.hide()
	credits_margin.hide()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
