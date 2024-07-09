class_name Box extends RawMaterial

static var MATERIAL_ID = 3

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return preload("res://raw_materials/box/box.png")
