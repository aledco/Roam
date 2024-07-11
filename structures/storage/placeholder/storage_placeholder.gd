class_name StoragePlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Vector2i(1, 1)

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/storage/storage.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Storage",
		1,
		preload("res://structures/storage/placeholder/storage_placeholder.tscn"),
		preload("res://structures/storage/storage_display.png"))
