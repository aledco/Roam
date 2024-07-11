class_name WorkshopPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/workshop/workshop.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		1, 
		preload("res://structures/workshop/placeholder/workshop_placeholder.tscn"),
		preload("res://structures/workshop/workshop_display.png"))
