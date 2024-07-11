class_name CurvedConveyorRightPlaceholder extends ConveyorPlaceholder

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/curved_conveyor/right/curved_conveyor_right.tscn")

static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Right",
		1, 
		preload("res://structures/conveyors/curved_conveyor/right/placeholder/curved_conveyor_right_placeholder.tscn"),
		preload("res://structures/conveyors/curved_conveyor/right/curved_conveyor_right.png"))
	
