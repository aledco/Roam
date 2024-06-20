extends Structure

func _get_build_list() -> Array[StructureModel]:
	return [
		StructureModel.create(self, 
			"Tree Cutter", 1, preload("res://structures/tree/tree_cutter/tree_cutter.tscn"), 
			preload("res://structures/tree/tree_cutter/tree_cutter.png")),
	]


func get_grid_size() -> Vector2i:
	return Vector2i(1, 2)
