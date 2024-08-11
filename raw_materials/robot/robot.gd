class_name Robot extends RawMaterial

static var MATERIAL_ID = 16
static var NAME = "Robot"
static var IMAGE = preload("res://raw_materials/robot/robot.png")
static var INGREDIENTS = [
	[ReinforcedBox.MATERIAL_ID, 1], 
	[Computer.MATERIAL_ID, 1]
]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
