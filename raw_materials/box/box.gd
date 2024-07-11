class_name Box extends RawMaterial

static var MATERIAL_ID = 3

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return preload("res://raw_materials/box/box.png")

static func get_model(parent: Structure) -> MaterialModel:
	return MaterialModel.create(
		parent, 
		"Box", 
		MATERIAL_ID,
		preload("res://raw_materials/box/box.tscn"),
		preload("res://raw_materials/box/box.png"))
