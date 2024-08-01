class_name IronIngot extends RawMaterial

static var MATERIAL_ID = 9
static var NAME = "Iron Ingot"
static var IMAGE = preload("res://raw_materials/iron_ingot/iron_ingot.png")
static var INGREDIENTS = []

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
