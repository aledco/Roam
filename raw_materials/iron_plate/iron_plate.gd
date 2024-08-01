class_name IronPlate extends RawMaterial

static var MATERIAL_ID = 11
static var NAME = "Iron Plate"
static var IMAGE = preload("res://raw_materials/iron_plate/iron_plate.png")
static var INGREDIENTS = [[IronIngot.MATERIAL_ID, 2]]

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
