class_name WorkshopPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop.GRID_SIZE

func _get_structure() -> Resource:
	return preload("res://structures/buildings/workshop/workshop.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		Workshop.COST,
		preload("res://structures/buildings/workshop/placeholder/workshop_placeholder.tscn"),
		preload("res://structures/buildings/workshop/workshop.png"))
