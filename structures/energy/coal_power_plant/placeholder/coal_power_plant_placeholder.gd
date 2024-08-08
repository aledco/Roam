class_name CoalPowerPlantPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return CoalPowerPlant.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/energy/coal_power_plant/coal_power_plant.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Coal Power Plant",
		CoalPowerPlant.COST,
		preload("res://structures/energy/coal_power_plant/placeholder/coal_power_plant_placeholder.tscn"),
		preload("res://structures/energy/coal_power_plant/coal_power_plant.png"))
