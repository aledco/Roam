class_name ReinforcedBox extends RawMaterial

static var MATERIAL_ID = 5
static var NAME = "Reinforced Box"
static var IMAGE = preload("res://raw_materials/reinforced_box/reinforced_box.png")
static var INGREDIENTS = [[Box.MATERIAL_ID, 1], [IronPlate.MATERIAL_ID, 2]]

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
