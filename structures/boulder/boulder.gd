class_name BoulderStructure extends Structure

static var GRID_SIZE = Vector2i(2, 2)

func _get_build_list() -> Array[StructureModel]:
	return [
		StructureModel.create(self, 
			"Stone Cutter", 1, preload("res://structures/boulder/stone_cutter/stone_cutter.tscn"), 
			preload("res://structures/boulder/stone_cutter/stone_cutter.png")),
	]


func get_grid_size() -> Vector2i:
	return GRID_SIZE


static func get_spawn_data():
	return {}
	#{
		#"resource": load("res://structures/boulder/boulder.tscn"),
		#"grid_size": GRID_SIZE
	#}
