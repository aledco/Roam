class_name CopperIngot extends RawMaterial

static var MATERIAL_ID = 10
static var NAME = "Copper Ingot"
static var IMAGE = preload("res://raw_materials/copper_ingot/copper_ingot.png")
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
