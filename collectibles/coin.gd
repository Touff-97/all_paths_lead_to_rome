@tool
extends Area3D

@onready var coin_type_node: MeshInstance3D = $CoinType

@export_enum("bronze", "silver", "gold") var coin_type: String = "bronze"

signal collected(type)


func _ready() -> void:
	coin_type_node.mesh = load("res://assets/levels/Models/OBJ format/coin-%s.obj" % coin_type)


func _process(delta: float) -> void:
	coin_type_node.mesh = load("res://assets/levels/Models/OBJ format/coin-%s.obj" % coin_type)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		emit_signal("collected", coin_type)
		call_deferred("queue_free")


func _on_collected(type: Variant) -> void:
	GameManager.gain_coins(type)
