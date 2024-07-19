extends RawMaterial

static var MATERIAL_ID = 15
static var NAME = "Computer"
static var IMAGE = preload("res://raw_materials/computer/computer.png")
static var INGREDIENTS = [
	[ReinforcedBox.MATERIAL_ID, 1], 
	[Processor.MATERIAL_ID, 1]
]

static func get_model(parent: Structure) -> MaterialModel:
	return MaterialModel.create(
		parent, 
		NAME, 
		MATERIAL_ID,
		IMAGE)

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return IMAGE
