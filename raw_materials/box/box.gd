class_name Box extends RawMaterial

static var MATERIAL_ID = 3
static var NAME = "Box"
static var IMAGE = preload("res://raw_materials/box/box.png")
static var INGREDIENTS = [[Plank.MATERIAL_ID, 2]]

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
