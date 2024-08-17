class_name Plank extends RawMaterial

static var MATERIAL_ID = 4
static var NAME = "Plank"
static var IMAGE = preload("res://raw_materials/plank/plank.png")
static var INGREDIENTS = [[Wood.MATERIAL_ID, 1]]
static var FUEL = 1
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID

