class_name WorkshopPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Workshop.GRID_SIZE


func _get_structure() -> Resource:
	return preload("res://structures/workshop/workshop.tscn")
