extends Panel

# purple: color: #6e32d6, cost: 5
# blue: color: #5d76cd, cost: 10
# gold: color: #fac75b, cost: 15
@onready var image: TextureRect = $Margin/VBox/Image
@onready var cost: Label = $Margin/VBox/Cost
@onready var buy_button: Button = $Margin/VBox/BuyButton

@export_enum("purple", "blue", "gold") var type : String = "purple"

signal difficulty_decreased


func _process(delta: float) -> void:
	image.set("modulate", GameManager.crystals[type]["color"])
	cost.set("theme_override_colors/font_color", GameManager.crystals[type]["color"])
	cost.text = "%03d" % GameManager.crystals[type]["cost"]
	set("tooltip_text", GameManager.crystals[type]["description"])
	
	if not GameManager.can_buy_crystal(type):
		buy_button.disabled = true
	else:
		buy_button.disabled = false


func _make_custom_tooltip(for_text):
	var label = Label.new()
	label.custom_minimum_size.x = 240
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.text = for_text
	return label


func _on_buy_button_pressed() -> void:
	if GameManager.can_buy_crystal(type):
		GameManager.gain_crystal(type)
		GameManager.increase_price(type)
	
	if GameManager.has_crystal("gold"):
		print("has golden crystal")
		GameManager.decrease_difficulty()
		GameManager.decrease_difficulty()
		GameManager.decrease_difficulty()
		GameManager.decrease_difficulty()
		GameManager.consume_crystal("gold")
		emit_signal("difficulty_decreased")
