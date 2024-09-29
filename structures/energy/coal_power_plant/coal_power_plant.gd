class_name CoalPowerPlant extends PowerPlant

static var COST := [[IronIngot.MATERIAL_ID, 5], [StoneBrick.MATERIAL_ID, 5]]

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _get_energy_rate() -> int:
	return 5

func _get_max_energy_stored() -> int:
	return 20

func _get_fuel_material_id() -> int:
	return Coal.MATERIAL_ID
