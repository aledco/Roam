class_name CopperDeposit extends MinableStructure

static var GRID_SIZE = Vector2i(1, 1)

func _get_build_list() -> Array[StructureModel]:
	if is_robot_mining:
		return [
			StructureModel.create(null, "Copper Deposit", 1, null, preload("res://structures/natural/copper_deposit/copper_deposit.png"), _remove_robot.bind())
		]
	else:
		return [
			StructureModel.create(null, "Drill", 1, null, preload("res://robots/drill_robot/drill_robot_display.png"), _place_robot.bind())
		]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Copper.MATERIAL_ID

func _can_drill() -> bool:
	return true && not is_robot_mining

func get_robot_position() -> Vector2:
	return Vector2(-15, 10)
