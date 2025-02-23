extends CanvasLayer

@onready var hud: MarginContainer = $HUD
@onready var pause_menu: MarginContainer = $PauseMenu
@onready var game_over_menu: TextureRect = $GameOverMenu
@onready var map: TextureRect = $Map


func _ready() -> void:
	pause_menu.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().is_paused():
			hud.show()
			pause_menu.hide()
			get_tree().paused = false
		else:
			hud.hide()
			pause_menu.show()
			get_tree().paused = true
	
	if event.is_action_pressed("reset"):
		if game_over_menu.visible and GameManager.has_crystal("purple"):
			print("reset")
			get_tree().paused = false
			hud.show()
			game_over_menu.hide()
			GameManager.reload_level()
			GameManager.consume_crystal("purple")
	
	if event.is_action_pressed("map") and GameManager.has_crystal("blue"):
		if game_over_menu.visible:
			print("map")
			get_tree().paused = false
			map.show()
			game_over_menu.hide()
	
	if event.is_action_pressed("die"):
		if game_over_menu.visible:
			print("die")
			get_tree().paused = false
			GameManager.restart_game()
			game_over_menu.hide()
			map.show()


func trigger_game_over() -> void:
	hud.hide()
	game_over_menu.show()
	get_tree().paused = true
