class_name Wood extends RawMaterial

static var MATERIAL_ID = 1
static var NAME = "Wood"
static var IMAGE = preload("res://raw_materials/wood/wood.png")
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

func get_fuel_value() -> int:
	return 1
