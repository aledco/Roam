class_name StoneBrick extends RawMaterial

static var MATERIAL_ID = 12
static var NAME = "Stone Brick"
static var IMAGE = preload("res://raw_materials/stone_brick/stone_brick.png")
static var INGREDIENTS = [[Stone.MATERIAL_ID, 1]]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
