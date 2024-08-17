class_name CopperIngot extends RawMaterial

static var MATERIAL_ID = 10
static var NAME = "Copper Ingot"
static var IMAGE = preload("res://raw_materials/copper_ingot/copper_ingot.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
