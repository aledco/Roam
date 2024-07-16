extends Node

#var MATERIAL_REFERENCES = []

class Config:
	var scene_path: String
	var material_script: GDScript
	
	static func create(scene_path: String, material_script: GDScript) -> Config:
		var config := Config.new()
		config.scene_path = scene_path
		config.material_script = material_script
		return config

var material_configs: Array[Config] = []
var material_ids: Array[int] = []

func _ready():
	const base_path := "res://raw_materials"
	var dir := DirAccess.open(base_path)
	if dir:
		dir.list_dir_begin()
		var item := dir.get_next()
		while item != "":
			if dir.current_is_dir():
				var path := base_path + "/" + item + "/" + item
				var script_path := path + ".gd"
				var script = load(script_path)
				var config = Config.create(path + ".tscn", script)
				material_configs.append(config)
				material_ids.append(script.MATERIAL_ID)
			item = dir.get_next()
	material_configs.sort_custom(func(a, b): return a.material_script.MATERIAL_ID < b.material_script.MATERIAL_ID)
	material_ids.sort()


## Gets the ids of the materials needed to produce the given material.
func get_material_ingredients(material_id: int) -> Array:
	var config := material_configs[material_id - 1]
	return config.material_script.INGREDIENTS


func get_amount_of_ingredients(material_id: int) -> int:
	var ingredients = get_material_ingredients(material_id)
	var count = 0
	for i in ingredients:
		count += i[1]
	return count


func get_model(material_id: int, parent: BaseWorkshop) -> MaterialModel:
	var config := material_configs[material_id - 1]
	return config.material_script.get_model(parent)


func instantiate_material(material_id) -> RawMaterial:
	var config := material_configs[material_id - 1]
	var path := config.scene_path
	var instance = load(path).instantiate()
	instance.set_script(config.material_script)
	return instance as RawMaterial
