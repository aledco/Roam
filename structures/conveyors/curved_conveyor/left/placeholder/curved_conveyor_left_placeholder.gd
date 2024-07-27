class_name CurvedConveyorLeftPlaceholder extends ConveyorPlaceholder

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/curved_conveyor/left/curved_conveyor_left.tscn")
		


static func get_model() -> StructureModel:
	return StructureModel.create(
		null,
		"Left",
		1, 
		preload("res://structures/conveyors/curved_conveyor/left/placeholder/curved_conveyor_left_placeholder.tscn"),
		preload("res://structures/conveyors/curved_conveyor/left/curved_conveyor_left_display.png"))
