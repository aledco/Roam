class_name TreeStructure extends MinableStructure

static var GRID_SIZE = Vector2i(1, 2)

func _get_build_list() -> Array[StructureModel]:
	return [
		StructureModel.create(null, "Saw", 1, null, preload("res://robots/saw_robot/saw_robot_display.png"), _place_robot.bind())
	]


func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_production_material_id() -> int:
	return Wood.MATERIAL_ID

func _can_saw() -> bool:
	return true

func get_robot_position() -> Vector2:
	return Vector2(-12, 16)
