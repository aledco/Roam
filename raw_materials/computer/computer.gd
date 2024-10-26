class_name Computer extends RawMaterial

static var MATERIAL_ID = 15
static var NAME = "Computer"
static var IMAGE = preload("res://raw_materials/computer/computer.png")
static var INGREDIENTS = [
	[ReinforcedBox.MATERIAL_ID, 1], 
	[Processor.MATERIAL_ID, 1]
]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
