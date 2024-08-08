class_name Furnace extends Building

static var COST := [[IronIngot.MATERIAL_ID, 5], [StoneBrick.MATERIAL_ID, 5]]

@onready var smoke: Smoke = $Smoke

var fuel := 0

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _play_default_animation():
	if smoke.is_active:
		smoke.dissapate()

func _play_operate_animation():
	if not smoke.is_active:
		smoke.start()

func can_accept_material(material: RawMaterial):
	if not super.can_accept_material(material):
		return false
	
	if not material.is_fuel() and not material.is_smeltable():
		return false 
	
	if material.is_smeltable() and fuel == 0:
		return false
	
	return true

func _process_material_in_building(material: RawMaterial, processed_materials: Array[RawMaterial]):
	if material.is_fuel():
		var mat_fuel = material.get_fuel_value()
		if mat_fuel > fuel:
			fuel = mat_fuel
		Helpers.remove_and_free(materials, material)
	elif material.is_smeltable():
		if fuel > 0:
			fuel -= 1
			processed_materials.append(material)
		else:
			Helpers.remove_and_free(materials, material)


func _process_materials_in_building(processed_materials: Array[RawMaterial], operational_outputs: Array[OutputNode]):
	for material in processed_materials:
		if len(operational_outputs) == 0:
			Helpers.remove_and_free(materials, material)
			continue
		
		var operational_output = get_next_output(operational_outputs)
		if operational_output == null:
			Helpers.remove_and_free(materials, material)
			continue
		
		var new_mat = material.get_smelted_material()
		material_node.add_child(new_mat)
		new_mat.mock_follow_node = PathFollow2D.new()
		new_mat.mock_follow_node.loop = false
		new_mat.parent = self
		new_mat.disable_collision()
		operational_output.path.add_child(new_mat.mock_follow_node)
		new_mat.global_position = new_mat.mock_follow_node.global_position
		materials_for_output.append(new_mat)
		materials.append(new_mat)
		Helpers.remove_and_free(materials, material)
