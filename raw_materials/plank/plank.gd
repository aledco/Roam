class_name Plank extends RawMaterial

static var MATERIAL_ID = 4
static var NAME = "Plank"
static var IMAGE = preload("res://raw_materials/plank/plank.png")
static var INGREDIENTS = [[Wood.MATERIAL_ID, 1]]

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
