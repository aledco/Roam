class_name UraniumRod extends RawMaterial

static var MATERIAL_ID = 18
static var NAME = "Uranium Rod"
static var IMAGE = preload("res://raw_materials/uranium_rod/uranium_rod.png")
static var INGREDIENTS = [[Uranium.MATERIAL_ID, 3]]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
