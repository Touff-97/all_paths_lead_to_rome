extends TextureRect

@onready var die_label: Label = $Margin/VBox/HBox/DieLabel
@onready var restart_label: Label = $Margin/VBox/HBox/RestartLabel
@onready var map_label: Label = $Margin/VBox/HBox/MapLabel

@export var coins_label : Label
@export var speed : Label
@export var level : Label


func _ready() -> void:
	GameManager.connect("coins_changed", _on_coins_changed)


func _process(delta: float) -> void:
	if die_label:
		die_label.set_visible(true)
	if restart_label:
		restart_label.set_visible(GameManager.has_crystal("purple"))
	if map_label:
		map_label.set_visible(GameManager.has_crystal("blue"))


func _on_visibility_changed() -> void:
	if visible:
		coins_label.text = "%03d" % GameManager.coins
		speed.text = "x%2.2f>>x%2.2f" % [GameManager.map_speed - 0.25, GameManager.map_speed]
		level.text = str(GameManager.current_level.split("_")[-1].split(".")[0])


func _on_coins_changed(coins: int) -> void:
	print(coins)
	coins_label.text = "%03d" % coins


func _on_card_difficulty_decreased() -> void:
	speed.text = "x%2.2f<<x%2.2f" % [GameManager.map_speed, GameManager.map_speed + 0.5]
