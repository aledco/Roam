class_name Workshop1Placeholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop1.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/workshop/workshop1/workshop1.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		1, 
		preload("res://structures/workshop/workshop1/placeholder/workshop1_placeholder.tscn"),
		preload("res://structures/workshop/workshop1/workshop1_display.png"))