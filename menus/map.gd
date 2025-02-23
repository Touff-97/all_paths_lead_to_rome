extends TextureRect

signal level_selected(level)


func _ready() -> void:
	for child in get_children():
		if child is TextureButton:
			child.connect("level_selected", _on_level_selected)
		print(child.is_connected("level_selected", _on_level_selected))
	
	if GameManager.traversed_levels.is_empty():
		print("no traversed levels")
		for child in get_children():
			if child is TextureButton and not child.get_index() == 0:
				child.disabled = true
		get_child(0).disabled = false


func _on_level_selected(level: String) -> void:
	if GameManager.has_crystal("blue"):
		GameManager.consume_crystal("blue")
		for i in range(GameManager.traversed_levels.size() - 1, -1, -1):
			if GameManager.traversed_levels[i] == level:
				break
			GameManager.traversed_levels.remove_at(i)
	print("Level selected")
	emit_signal("level_selected", level)


func _on_visibility_changed() -> void:
	if visible:
		print("map visible")
		
		for child in get_children():
			child.disabled = true
			child.is_explored = false
		
		if GameManager.traversed_levels.is_empty():
			get_child(0).disabled = false
			get_child(0).is_explored = false
		
		for i in range(GameManager.traversed_levels.size()):
			var level_name = GameManager.traversed_levels[i].split("/")[-1].split(".")[0]
			var level_node = get_node(level_name[0].to_upper() + level_name.substr(1, -1))
			if i < GameManager.traversed_levels.size() - 1:
				print("%s is enabled" % level_name)
				level_node.disabled = false
				level_node.is_explored = false
			else:
				level_node.disabled = true
				level_node.is_explored = true
		
		if GameManager.has_crystal("blue"):
			for i in range(GameManager.traversed_levels.size()):
				var level_name = GameManager.traversed_levels[i].split("/")[-1].split(".")[0]
				var level_node = get_node(level_name[0].to_upper() + level_name.substr(1, -1))
				print("%s is enabled" % level_name)
				level_node.disabled = false
				level_node.is_explored = false
		
		print(GameManager.traversed_levels)
