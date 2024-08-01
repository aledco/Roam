class_name StoneBrick extends RawMaterial

static var MATERIAL_ID = 12
static var NAME = "Stone Brick"
static var IMAGE = preload("res://raw_materials/stone_brick/stone_brick.png")
static var INGREDIENTS = [[Stone.MATERIAL_ID, 1]]

@warning_ignore("shadowed_variable")
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
