class_name ConveyorPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _get_structure() -> Resource:
	return preload("res://structures/conveyors/conveyor/conveyor.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		"Conveyor",
		Conveyor.COST, 
		preload("res://structures/conveyors/conveyor/placeholder/conveyor_placeholder.tscn"),
		preload("res://structures/conveyors/conveyor/conveyor_display.png"))
