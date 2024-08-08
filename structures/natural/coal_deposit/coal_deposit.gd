class_name CoalDeposit extends MinableStructure

static var GRID_SIZE = Vector2i(1, 1)

func _get_build_list() -> Array[StructureModel]:
	if is_robot_mining:
		return [
			StructureModel.create(null, "Coal Deposit", [], null, preload("res://structures/natural/coal_deposit/coal_deposit.png"), _remove_robot.bind())
		]
	else:
		return [_get_robot_model()]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Coal.MATERIAL_ID

func _can_drill() -> bool:
	return true && not is_robot_mining

func get_robot_position() -> Vector2:
	return Vector2(-15, 10)
