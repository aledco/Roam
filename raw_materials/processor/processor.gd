class_name Processor extends RawMaterial

static var MATERIAL_ID = 14
static var NAME = "Processor"
static var IMAGE = preload("res://raw_materials/processor/processor.png")
static var INGREDIENTS = [
	[IronIngot.MATERIAL_ID, 1], 
	[CopperWire.MATERIAL_ID, 1]
]
static var FUEL = 0
static var SMELT_TARGET_ID = -1

func get_material_id() -> int:
	return MATERIAL_ID
