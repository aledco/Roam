class_name Copper extends RawMaterial

static var MATERIAL_ID = 8
static var NAME = "Copper"
static var IMAGE = preload("res://raw_materials/copper/copper.png")
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

func is_smeltable() -> bool:
	return true

func _get_smelted_material_id() -> int:
	return CopperIngot.MATERIAL_ID
