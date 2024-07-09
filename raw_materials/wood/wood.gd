class_name Wood extends RawMaterial

static var MATERIAL_ID = 1

func get_material_id() -> int:
	return MATERIAL_ID

func get_material_image() -> Texture2D:
	return preload("res://raw_materials/wood/wood.png")
