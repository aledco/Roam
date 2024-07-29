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
	
	for i in range(len(material_ids)):
		for j in range(len(material_ids)):
			if i != j:
				assert(material_ids[i] != material_ids[j], "Duplicate Material Id: " + str(material_ids[i]))


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


func has_sufficient_ingredients(material_id: int, ingridents: Array[RawMaterial]) -> Array:
	var has_enough = func(needed_mat_id: int, needed_mat_amount: int):
		var count = 0
		for material in ingridents:
			if material.get_material_id() == needed_mat_id:
				count += 1
		return count >= needed_mat_amount
	
	var needed_ingridents = get_material_ingredients(material_id)
	var used = []
	for mat_config in needed_ingridents:
		var needed_mat_id = mat_config[0]
		var needed_mat_amount = mat_config[1]
		if not has_enough.call(needed_mat_id, needed_mat_amount):
			return [false, []]
		else:
			for material in ingridents:
				if material.get_material_id() == needed_mat_id:
					used.append(material)
					needed_mat_amount -= 1
					if needed_mat_amount == 0:
						break
	return [true, used]


func get_model(material_id: int, parent: Structure) -> MaterialModel:
	var config := material_configs[material_id - 1]
	return config.material_script.get_model(parent)


func instantiate_material(material_id) -> RawMaterial:
	var config := material_configs[material_id - 1]
	var path := config.scene_path
	var instance = load(path).instantiate()
	instance.set_script(config.material_script)
	return instance as RawMaterial
