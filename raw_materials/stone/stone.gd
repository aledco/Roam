class_name Stone extends RawMaterial

static var MATERIAL_ID = 2
static var NAME = "Stone"
static var IMAGE = preload("res://raw_materials/stone/stone.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
