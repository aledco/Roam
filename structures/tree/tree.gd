class_name TreeStructure extends Structure

static var GRID_SIZE = Vector2i(1, 2)

func _get_build_list() -> Array[StructureModel]:
	return [
		StructureModel.create(self, 
			"Tree Cutter", 1, preload("res://structures/tree/tree_cutter/tree_cutter.tscn"), 
			preload("res://structures/tree/tree_cutter/tree_cutter.png")),
	]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

static func get_spawn_data():
	return {}
	#{
		##"resource": load("res://structures/tree/tree.tscn"),
		##"grid_size": GRID_SIZE
	#}
