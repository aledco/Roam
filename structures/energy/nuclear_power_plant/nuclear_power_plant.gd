class_name NuclearPowerPlant extends PowerPlant

static var COST := [[IronIngot.MATERIAL_ID, 10], [StoneBrick.MATERIAL_ID, 10]]

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_energy_rate() -> int:
	return 20

func _get_max_energy_stored() -> int:
	return 100

func _get_fuel_material_id() -> int:
	return UraniumRod.MATERIAL_ID
