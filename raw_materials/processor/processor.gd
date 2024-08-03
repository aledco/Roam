class_name Processor extends RawMaterial

static var MATERIAL_ID = 14
static var NAME = "Processor"
static var IMAGE = preload("res://raw_materials/processor/processor.png")
static var INGREDIENTS = [
	[IronIngot.MATERIAL_ID, 1], 
	[CopperWire.MATERIAL_ID, 1]
]

static func get_model(parent: Variant) -> MaterialModel:
	return MaterialModel.create(
		parent, 
		NAME, 
		MATERIAL_ID,
		IMAGE)

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return IMAGE
