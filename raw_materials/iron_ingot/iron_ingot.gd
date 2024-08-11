class_name IronIngot extends RawMaterial

static var MATERIAL_ID = 9
static var NAME = "Iron Ingot"
static var IMAGE = preload("res://raw_materials/iron_ingot/iron_ingot.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
