class_name Merger extends PathedStructure


# TODO need to make paths connect and input to an output
# TODO need to not move materials until it is their turn

func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _ready():
	super._ready()
	
	assert(inputs.size() == 2)
	assert(outputs.size() == 1)
	
	inputs[0].setup(self, Vector2i.ZERO, PI/2)
	inputs[1].setup(self, Vector2i.ZERO, -PI/2)
	outputs[0].setup(self, Vector2i.ZERO, 0)
