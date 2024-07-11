class_name Workshop1 extends BaseWorkshop

static var GRID_SIZE: Vector2i = Vector2i(1, 2)

func get_grid_size() -> Vector2i:
	return GRID_SIZE

func get_num_inputs() -> int:
	return 1

func _setup_io():
	assert(inputs.size() == 1)
	assert(outputs.size() == 1)
	assert(paths.size() == 2)
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]
	outputs[0].setup(self, Vector2i(0, 1), 0)
