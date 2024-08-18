class_name TreeStructure extends NaturalStructure

static var GRID_SIZE = Vector2i(1, 2)

func _get_build_list() -> Array[StructureModel]:
	if is_robot_mining:
		return [
			StructureModel.create("Tree", [], null, preload("res://structures/natural/tree/tree.png"), _remove_robot.bind())
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

static func get_probability_model() -> SpawnProbabilityModel:
	return SpawnProbabilityModel.create(
		preload("res://structures/natural/tree/tree.tscn"),
		GRID_SIZE,
		{
			World.DIRT_TILE_ID: 0.25,
			World.GRASS_TILE_ID: 0.25,
			World.GRAVEL_TILE_ID: 0.05,
			World.SAND_TILE_ID: 0.05
		})
