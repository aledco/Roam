class_name Coal extends RawMaterial

static var MATERIAL_ID = 7
static var NAME = "Coal"
static var IMAGE = preload("res://raw_materials/coal/coal.png")
static var INGREDIENTS = []
static var FUEL = 3
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
