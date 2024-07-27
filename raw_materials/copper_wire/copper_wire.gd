class_name CopperWire extends RawMaterial

static var MATERIAL_ID = 13
static var NAME = "Copper Wire"
static var IMAGE = preload("res://raw_materials/copper_wire/copper_wire.png")
static var INGREDIENTS = [[CopperIngot.MATERIAL_ID, 1]]

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
