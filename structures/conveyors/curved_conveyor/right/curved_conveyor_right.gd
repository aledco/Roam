class_name CurvedConveyorRight extends Conveyor

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, -PI/2)


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Right Conveyor",
		1, 
		preload("res://structures/conveyors/curved_conveyor/right/placeholder/curved_conveyor_right_placeholder.tscn"),
		preload("res://structures/conveyors/curved_conveyor/right/curved_conveyor_right.png"))
