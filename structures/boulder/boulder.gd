class_name BoulderStructure extends MinableStructure

static var GRID_SIZE = Vector2i(1, 1)

func _get_build_list() -> Array[StructureModel]:
	return [
		StoneCutter.get_model(self)
	]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Stone.MATERIAL_ID

func _can_drill() -> bool:
	return true

func get_player_position() -> Vector2:
	return to_global(Vector2(-15, 10))
