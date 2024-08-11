class_name Iron extends RawMaterial

static var MATERIAL_ID = 6
static var NAME = "Iron"
static var IMAGE = preload("res://raw_materials/iron/iron.png")
static var INGREDIENTS = []
static var FUEL = 0
static var SMELT_TARGET_ID = IronIngot.MATERIAL_ID

func get_material_id() -> int:
	return MATERIAL_ID
