class_name Workshop3Placeholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop3.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/workshop/workshop3/workshop3.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		1, 
		preload("res://structures/workshop/workshop3/placeholder/workshop3_placeholder.tscn"),
		preload("res://structures/workshop/workshop3/workshop3_display.png"))
