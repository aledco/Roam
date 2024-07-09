class_name CurvedConveyorLeft extends Conveyor

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, PI/2)


static func get_model() -> StructureModel:
	return StructureModel.create(
		null,
		"Left Conveyor",
		1, 
		preload("res://structures/conveyors/curved_conveyor/left/placeholder/curved_conveyor_left_placeholder.tscn"),
		preload("res://structures/conveyors/curved_conveyor/left/curved_conveyor_left.png"))
