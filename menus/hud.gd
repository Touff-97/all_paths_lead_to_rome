extends MarginContainer

@onready var coins_counter: Label = $HBox/VBox/Coins/CoinsCounter
@onready var level_indicator: Label = $HBox/Level/LevelIndicator
@onready var map_speed_label: Label = $HBox/MapSpeedLabel


func _ready() -> void:
	GameManager.connect("coins_changed", _on_coins_changed)
	GameManager.connect("level_changed", _on_level_changed)
	GameManager.connect("map_speed_changed", _on_map_speed_changed)
	
	map_speed_label.text = "x%2.2f" % GameManager.map_speed


func _on_coins_changed(coins: int) -> void:
	coins_counter.text = "      %03d" % coins


func _on_level_changed(level: String) -> void:
	level_indicator.text = "%s   " % level.split("_")[-1].split(".")[0]


func _on_map_speed_changed(speed: float) -> void:
	print("Speed: ", speed)
	map_speed_label.text = "x%2.2f" % speed
