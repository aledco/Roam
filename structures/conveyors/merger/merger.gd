class_name Merger extends MultiInputPathedStructure

func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _ready():
	super._ready()
	
	assert(inputs.size() == 2)
	assert(outputs.size() == 1)
	assert(paths.size() == 2)
	
	inputs[0].setup(self, Vector2i.ZERO, PI/2)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i.ZERO, -PI/2)
	inputs[1].path = paths[1]
	outputs[0].setup(self, Vector2i.ZERO, 0)


func _physics_process(delta):
	for material in materials:
		if material.at_exit_node:
			continue
		
		var output = _get_output(material)
		if output == null:
			if material.try_move(delta * speed):
				break
		else:
			output.material_to_output = true
			material.at_exit_node = true

