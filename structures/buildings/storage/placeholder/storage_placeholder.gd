class_name StoragePlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Storage.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/buildings/storage/storage.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		"Storage",
		Storage.COST,
		preload("res://structures/buildings/storage/placeholder/storage_placeholder.tscn"),
		preload("res://structures/buildings/storage/storage.png"))
