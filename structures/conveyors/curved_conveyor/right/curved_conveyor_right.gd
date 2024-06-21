class_name CurvedConveyorRight extends Conveyor

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, -PI/2)
