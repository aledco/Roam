class_name Iron extends RawMaterial

static var MATERIAL_ID = 6
static var NAME = "Iron"
static var IMAGE = preload("res://raw_materials/iron/iron.png")
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

func is_smeltable() -> bool:
	return true

func _get_smelted_material_id() -> int:
	return IronIngot.MATERIAL_ID