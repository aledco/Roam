extends Node


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


func get_material_image(material_id: int) -> Texture2D:
	var config := material_configs[material_id - 1]
	return config.material_script.IMAGE

## Gets the ids of the materials needed to produce the given material.
func get_material_ingredients(material_id: int) -> Array:
	var config := material_configs[material_id - 1]
	return config.material_script.INGREDIENTS

func get_material_fuel_value(material_id: int) -> int:
	var config := material_configs[material_id - 1]
	return config.material_script.FUEL

func is_material_fuel(material_id: int) -> bool:
	var fuel := get_material_fuel_value(material_id)
	return fuel > 0

func get_smelt_target_id(material_id: int) -> int:
	var config := material_configs[material_id - 1]
	return config.material_script.SMELT_TARGET_ID

func is_material_smeltable(material_id: int) -> bool:
	var id := get_smelt_target_id(material_id)
	return id != -1

func get_material_name(material_id: int) -> String:
	var config := material_configs[material_id - 1]
	return config.material_script.NAME 

func get_amount_of_ingredients(material_id: int) -> int:
	var ingredients = get_material_ingredients(material_id)
	var count = 0
	for i in ingredients:
		count += i[1]
	return count

func has_sufficient_ingredients(material_id: int, ingredients: Array[RawMaterial]) -> Array:
	var has_enough = func(needed_mat_id: int, needed_mat_amount: int):
		var count = 0
		for material in ingredients:
			if material.get_material_id() == needed_mat_id:
				count += 1
		return count >= needed_mat_amount
	
	var needed_ingridents = get_material_ingredients(material_id)
	var used: Array[RawMaterial] = []
	for mat_config in needed_ingridents:
		var needed_mat_id = mat_config[0]
		var needed_mat_amount = mat_config[1]
		if not has_enough.call(needed_mat_id, needed_mat_amount):
			return [false]
		else:
			for material in ingredients:
				if material.get_material_id() == needed_mat_id:
					used.append(material)
					needed_mat_amount -= 1
					if needed_mat_amount == 0:
						break
	return [true, used]

func _are_ingredients_valid(ingredients_held: Array[int], ingredients_needed: Array) -> bool:
	var ingredients_used := 0
	for ingredient in ingredients_needed:
		var ingredient_id = ingredient[0]
		var ingredient_amount = ingredient[1]
		if not Helpers.contains_amount(ingredients_held, ingredient_id, ingredient_amount):
			return false
		else:
			ingredients_used += ingredient_amount
	return len(ingredients_held) == ingredients_used

func get_models_from_ingredients(ingredients_held: Array[int]) -> Array[MaterialModel]:
	var models: Array[MaterialModel] = []
	for config in material_configs:
		var material_id = config.material_script.MATERIAL_ID
		var ingredients_needed = config.material_script.INGREDIENTS
		if ingredients_needed.is_empty():
			continue
		if _are_ingredients_valid(ingredients_held, ingredients_needed):
			models.append(get_model(material_id, null))
	return models


func get_model(material_id: int, parent: Variant) -> MaterialModel:
	var config := material_configs[material_id - 1]
	return MaterialModel.create(
		parent,
		get_material_name(material_id), 
		material_id,
		get_material_image(material_id)
	)

func instantiate_material(material_id) -> RawMaterial:
	var config := material_configs[material_id - 1]
	var path := config.scene_path
	var instance = load(path).instantiate()
	instance.set_script(config.material_script)
	return instance as RawMaterial
