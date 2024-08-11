class_name CopperWire extends RawMaterial

static var MATERIAL_ID = 13
static var NAME = "Copper Wire"
static var IMAGE = preload("res://raw_materials/copper_wire/copper_wire.png")
static var INGREDIENTS = [[CopperIngot.MATERIAL_ID, 1]]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
