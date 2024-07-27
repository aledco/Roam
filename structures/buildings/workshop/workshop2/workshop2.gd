class_name Workshop2 extends BaseWorkshop

static var GRID_SIZE: Vector2i = Vector2i(2, 3)

func get_grid_size() -> Vector2i:
	return GRID_SIZE

func get_num_inputs() -> int:
	return 2

func _setup_io():
	assert(inputs.size() == 2)
	assert(outputs.size() == 1)
	assert(paths.size() == 3)
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i(1, 0), 0)
	inputs[1].path = paths[1]
	outputs[0].setup(self, Vector2i(1, 2), 0)
