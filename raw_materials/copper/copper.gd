class_name Copper extends RawMaterial

static var MATERIAL_ID = 8
static var NAME = "Copper"
static var IMAGE = preload("res://raw_materials/copper/copper.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = CopperIngot.MATERIAL_ID

func get_material_id() -> int:
	return MATERIAL_ID
