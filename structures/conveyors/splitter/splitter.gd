class_name Splitter extends PathedStructure

func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _ready():
	super._ready()
	
	assert(inputs.size() == 1)
	assert(outputs.size() == 2)
	
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, PI/2)
	outputs[1].setup(self, Vector2i.ZERO, -PI/2)
