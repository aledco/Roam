class_name ReinforcedBox extends RawMaterial

static var MATERIAL_ID = 5
static var NAME = "Reinforced Box"
static var IMAGE = preload("res://raw_materials/reinforced_box/reinforced_box.png")
static var INGREDIENTS = [[Box.MATERIAL_ID, 1], [IronPlate.MATERIAL_ID, 2]]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
