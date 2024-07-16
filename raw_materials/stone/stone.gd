class_name Stone extends RawMaterial

static var MATERIAL_ID = 2
static var NAME = "Stone"
static var IMAGE = preload("res://raw_materials/stone/stone.png")
static var INGREDIENTS = []

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
