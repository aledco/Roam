class_name CopperDeposit extends NaturalStructure

static var GRID_SIZE = Vector2i(1, 1)

func _get_build_list() -> Array[StructureModel]:
	if is_robot_mining:
		return [
			StructureModel.create("Copper Deposit", [], null, preload("res://structures/natural/copper_deposit/copper_deposit.png"), _remove_robot.bind())
		]
	else:
		return [_get_robot_model()]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Copper.MATERIAL_ID

func _can_drill() -> bool:
	return true && not is_robot_mining

func get_robot_position() -> Vector2:
	return Vector2(-15, 10)

static func get_probability_model() -> SpawnProbabilityModel:
	return SpawnProbabilityModel.create(
		func(): return preload("res://structures/natural/copper_deposit/copper_deposit.tscn"),
		GRID_SIZE,
		{
			World.DIRT_TILE_ID: 0.025,
			World.GRASS_TILE_ID: 0.025,
			World.GRAVEL_TILE_ID: 0.15,
			World.SAND_TILE_ID: 0.05
		})
