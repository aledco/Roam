class_name Box extends RawMaterial

static var MATERIAL_ID = 3
static var NAME = "Box"
static var IMAGE = preload("res://raw_materials/box/box.png")
static var INGREDIENTS = [[Plank.MATERIAL_ID, 2]]
static var FUEL = 1
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
