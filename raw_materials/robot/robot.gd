class_name Robot extends RawMaterial

static var MATERIAL_ID = 16
static var NAME = "Robot"
static var IMAGE = preload("res://raw_materials/robot/robot.png")
static var INGREDIENTS = [
	[ReinforcedBox.MATERIAL_ID, 1], 
	[Computer.MATERIAL_ID, 1]
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
