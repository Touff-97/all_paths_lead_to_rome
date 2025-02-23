extends Node

@export var map_speed : float = 1.0
@export var coins : int = 0
# purple: color: #6e32d6, cost: 5
# blue: color: #5d76cd, cost: 10
# gold: color: #fac75b, cost: 15
@export var crystals : Dictionary = {
	"purple": {
		"color": "#6e32d6",
		"cost": 5,
		"description": "Gives you the ability to erase your last death from the record.",
		"has": false
	},
	"blue": {
		"color": "#5d76cd",
		"cost": 10,
		"description": "Gives you the ability to erase your treaded path and start anew.",
		"has": false
	},
	"gold": {
		"color": "#fac75b",
		"cost": 15,
		"description": "Gives you the ability to erase your karma and lower the speed on which Death approaches you.",
		"has": false
	}
}
@export var purple_crystal : int = 0
@export var blue_crystal : int = 0
@export var gold_crystal : int = 0
@export_dir var traversed_levels : Array[String]
@export var current_level : String = ""

signal coins_changed(coins)
signal level_changed(level)
signal map_speed_changed(speed)
signal player_died


func gain_coins(type: String) -> void:
	match type:
		"bronze":
			coins += 1
		"silver":
			coins += 10
		"gold":
			coins += 100
		_:
			return
	
	emit_signal("coins_changed", coins)


func can_buy_crystal(type: String) -> bool:
	return (coins >= crystals[type]["cost"]) and not crystals[type]["has"]


func gain_crystal(type: String) -> void:
	coins -= crystals[type]["cost"]
	emit_signal("coins_changed", coins)
	crystals[type]["has"] = true


func consume_crystal(type: String) -> void:
	crystals[type]["has"] = false


func has_crystal(type: String) -> bool:
	return crystals[type]["has"]


func increase_price(type: String) -> void:
	crystals[type]["cost"] += 5


func save_level_as_traversed(level: String) -> void:
	if not level in traversed_levels:
		traversed_levels.append(level)
	current_level = level.get_file().split(".")[0]
	emit_signal("level_changed", level)
	print(traversed_levels)


func set_difficulty(value: float) -> void:
	map_speed = value


func increase_difficulty() -> void:
	map_speed += 0.25
	map_speed = clamp(map_speed, 1.0, 10.0)
	emit_signal("map_speed_changed", map_speed)


func decrease_difficulty() -> void:
	map_speed -= 0.25
	map_speed = clamp(map_speed, 1.0, 10.0)
	emit_signal("map_speed_changed", map_speed)


func reload_level() -> void:
	coins = 0
	emit_signal("coins_changed", 0)
	emit_signal("player_died")


func restart_game() -> void:
	traversed_levels.clear()
	coins = 0
	emit_signal("coins_changed", 0)
