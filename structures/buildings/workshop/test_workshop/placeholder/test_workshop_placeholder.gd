class_name TestWorkshopPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return TestWorkshop.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/buildings/workshop/test_workshop/test_workshop.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Test Workshop",
		1, 
		preload("res://structures/buildings/workshop/test_workshop/placeholder/test_workshop_placeholder.tscn"),
		preload("res://structures/buildings/workshop/test_workshop/test_workshop.png"))
