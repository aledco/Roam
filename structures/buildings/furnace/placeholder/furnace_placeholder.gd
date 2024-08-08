class_name FurnacePlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Furnace.GRID_SIZE

func _get_structure() -> Resource:
	return preload("res://structures/buildings/furnace/furnace.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Furnace",
		Furnace.COST,
		preload("res://structures/buildings/furnace/placeholder/furnace_placeholder.tscn"),
		preload("res://structures/buildings/furnace/furnace.png"))
