class_name TreeStructure extends MinableStructure

static var GRID_SIZE = Vector2i(1, 2)

func _get_build_list() -> Array[StructureModel]:
	if is_robot_mining:
		return [
			StructureModel.create(null, "Tree", [], null, preload("res://structures/natural/tree/tree.png"), _remove_robot.bind())
		]
	else:
		return [_get_robot_model()]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Wood.MATERIAL_ID

func _can_saw() -> bool:
	return true && not is_robot_mining

func get_robot_position() -> Vector2:
	return Vector2(-12, 16)
