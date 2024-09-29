class_name NuclearPowerPlantPlaceholder extends StructurePlaceholder

func get_grid_size() -> Vector2i:
	return NuclearPowerPlant.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/energy/nuclear_power_plant/nuclear_power_plant.tscn")


static func get_model() -> StructureModel:
	return StructureModel.create(
		"Nuclear Power Plant",
		NuclearPowerPlant.COST,
		preload("res://structures/energy/nuclear_power_plant/placeholder/nuclear_power_plant_placeholder.tscn"),
		preload("res://structures/energy/nuclear_power_plant/nuclear_power_plant.png"))
