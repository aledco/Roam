class_name Workshop2Placeholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop2.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/workshop/workshop2/workshop2.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		1, 
		preload("res://structures/workshop/workshop2/placeholder/workshop2_placeholder.tscn"),
		preload("res://structures/workshop/workshop2/workshop2_display.png"))
