class_name MergerPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Storage.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/buildings/merger/merger.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Merger",
		Merger.COST,
		preload("res://structures/buildings/merger/placeholder/merger_placeholder.tscn"),
		preload("res://structures/buildings/merger/merger.png"))
