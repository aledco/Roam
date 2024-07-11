class_name Plank extends RawMaterial

static var MATERIAL_ID = 4

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return preload("res://raw_materials/plank/plank.png")


static func get_model(parent: Structure) -> MaterialModel:
	return MaterialModel.create(
		parent, 
		"Plank", 
		MATERIAL_ID,
		preload("res://raw_materials/plank/plank.tscn"),
		preload("res://raw_materials/plank/plank.png"))
