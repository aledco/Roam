class_name Coal extends RawMaterial

static var MATERIAL_ID = 7
static var NAME = "Coal"
static var IMAGE = preload("res://raw_materials/coal/coal.png")
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
	return 3