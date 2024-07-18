class_name FurnacePlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Furnace.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/workshop/furnace/furnace.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Workshop",
		1, 
		preload("res://structures/workshop/furnace/placeholder/furnace_placeholder.tscn"),
		preload("res://structures/workshop/furnace/furnace_display.png"))

