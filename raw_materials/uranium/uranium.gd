class_name Uranium extends RawMaterial

static var MATERIAL_ID = 17
static var NAME = "Uranium"
static var IMAGE = preload("res://raw_materials/uranium/uranium.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
