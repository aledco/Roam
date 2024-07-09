class_name BoulderStructure extends Structure

static var GRID_SIZE = Vector2i(2, 2)

func _get_build_list() -> Array[StructureModel]:
	return [
		StoneCutter.get_model(self)
	]


func get_grid_size() -> Vector2i:
	return GRID_SIZE
