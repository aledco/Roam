class_name Wood extends RawMaterial

static var MATERIAL_ID = 1
static var NAME = "Wood"
static var IMAGE = preload("res://raw_materials/wood/wood.png")
static var INGREDIENTS = []
static var FUEL = 1
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
