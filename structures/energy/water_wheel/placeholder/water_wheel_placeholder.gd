class_name WaterWheelPlaceholder extends StructurePlaceholder

@onready var world := get_node("/root/World") as World

func get_grid_size() -> Vector2i:
	return WaterWheel.GRID_SIZE

func _destroy_after_placement() -> bool:
	return true

func _get_structure() -> Resource:
	return preload("res://structures/energy/water_wheel/water_wheel.tscn")

func _get_wheel_grid_index() -> Vector2i:
	var grid_index := get_grid_index()
	var dir_offset = Vector2i(direction.y, -direction.x)
	return grid_index + dir_offset

func is_valid():
	if not super.is_valid():
		return false
	
	var wheel_grid_index := _get_wheel_grid_index()
	var tile = world.get_tile_at_grid_index(wheel_grid_index)
	if tile != WorldTileType.Water:
		return false
	return true

static func get_model() -> StructureModel:
	return StructureModel.create(
		"Water Weel",
		WaterWheel.COST,
		preload("res://structures/energy/water_wheel/placeholder/water_wheel_placeholder.tscn"),
		preload("res://structures/energy/water_wheel/water_wheel_display.png"))
