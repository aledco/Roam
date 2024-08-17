class_name IronPlate extends RawMaterial

static var MATERIAL_ID = 11
static var NAME = "Iron Plate"
static var IMAGE = preload("res://raw_materials/iron_plate/iron_plate.png")
static var INGREDIENTS = [[IronIngot.MATERIAL_ID, 2]]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
