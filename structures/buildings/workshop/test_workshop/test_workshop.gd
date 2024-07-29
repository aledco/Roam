class_name TestWorkshop extends DelayedConnectionStructure

const TEST_MATERIAL_SELECT_UI = preload("res://ui/test_material_select/test_material_select_ui.tscn")

# TODO:
#	2. material select ui: indicate which one is currently selected
#	3. dont inheirit from pathed structure

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE


var material_models: Dictionary
var current_material: MaterialModel
var materials_for_output: Array[RawMaterial] = []
var current_output_index = 0

func set_current_material(material_model: MaterialModel) -> void:
	current_material = material_model


func can_accept_material(material: RawMaterial):
	var material_id = material.get_material_id()
	if not RawMaterial.is_ingredient(material_id, current_material.material_id):
		return false
	
	var operational_outputs = outputs.filter(func(output): return output.connection != null)
	if len(operational_outputs) == 0:
		return false
	
	if operational_outputs.all(func(output): return output.connection.is_full()):
		return false
	
	return true

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, PI, true)
	inputs[0].path = paths[0]
	inputs[1].setup(self, Vector2i.ZERO, -PI / 2, true)
	inputs[1].path = paths[1]
	inputs[2].setup(self, Vector2i.ZERO, 0, true)
	inputs[2].path = paths[2]
	inputs[3].setup(self, Vector2i.ZERO, PI / 2, true)
	inputs[3].path = paths[3]
	
	outputs[0].setup(self, Vector2i.ZERO, PI, true)
	outputs[0].path = paths[4]
	outputs[1].setup(self, Vector2i.ZERO, -PI / 2, true)
	outputs[1].path = paths[5]
	outputs[2].setup(self, Vector2i.ZERO, 0, true)
	outputs[2].path = paths[6]
	outputs[3].setup(self, Vector2i.ZERO, PI / 2, true)
	outputs[3].path = paths[7]


func _ready():
	super._ready()
	material_models = RawMaterial.get_models_for_test_workshop(self)
	current_material = material_models[1][0]


func _create_special_ui():
	var material_select_ui := TEST_MATERIAL_SELECT_UI.instantiate() as TestMaterialSelectUI
	add_child(material_select_ui)
	material_select_ui.create_material_selections(material_models)


func add_material(material: RawMaterial):
	material.parent = self
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	material.disable_collision()
	var input := _get_input(material)
	# sometimes add_material gets called before the input areas are ready, and don't detect the material
	while input == null:
		await get_tree().create_timer(.2).timeout
		if not is_instance_valid(material):
			return
		input = _get_input(material)
	input.path.add_child(material.mock_follow_node)
	materials.push_back(material)


func produce():
	if len(materials) == 0:
		return
	
	var operational_outputs = outputs.filter(func(output): return output.connection != null)
	var ingredients: Array[RawMaterial] = []
	for material in materials:
		if material in materials_for_output:
			continue
		if material.mock_follow_node.progress_ratio == 1:
			var material_id = material.get_material_id()
			if RawMaterial.is_ingredient(material_id, current_material.material_id):
				ingredients.append(material)
			else:
				materials.remove_at(materials.find(material))
				material.queue_free()
	
	var result = RawMaterialManager.has_sufficient_ingredients(current_material.material_id, ingredients)
	if result[0]:
		var used = result[1]
		for material in used:
			materials.remove_at(materials.find(material))
			material.queue_free()
		
		if len(operational_outputs) == 0:
			return
		
		var operational_output = get_next_output(operational_outputs)
		if operational_output == null:
			return
		
		var new_mat := RawMaterialManager.instantiate_material(current_material.material_id)
		material_node.add_child(new_mat)
		new_mat.mock_follow_node = PathFollow2D.new()
		new_mat.mock_follow_node.loop = false
		new_mat.parent = self
		new_mat.disable_collision() # TODO skip full outputs
		operational_output.path.add_child(new_mat.mock_follow_node)
		new_mat.global_position = new_mat.mock_follow_node.global_position
		materials_for_output.append(new_mat)
		materials.append(new_mat)
	
	for output in operational_outputs:
		if output.material_to_output:
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			var material = _get_material_to_exit(output)
			if not connected_structure.can_accept_material(material):
				continue
			
			materials.remove_at(materials.find(material))
			materials_for_output.remove_at(materials_for_output.find(material))
			material.enable_collision()
			material.at_exit_node = false
			connected_structure.add_material(material)
			output.material_to_output = false


func get_next_output(operational_outputs: Array[OutputNode]) -> OutputNode:
	if current_output_index >= len(operational_outputs):
		current_output_index = 0
	
	var start = current_output_index
	while operational_outputs[current_output_index].connection.is_full():
		current_output_index = (current_output_index + 1) % len(operational_outputs)
		if current_output_index == start:
			return null
		
	var output = operational_outputs[current_output_index]
	current_output_index = (current_output_index + 1) % len(operational_outputs)
	return output


func _get_material_to_exit(output: OutputNode):
	for material in materials_for_output:
		if material.at_exit_node and material in output.get_overlapping_bodies():
			return material

func _physics_process(delta):
	for material in materials:
		if not is_instance_valid(material) or material.at_exit_node:
			continue
		
		var output = _get_output(material)
		if output == null:
			material.try_move(delta * speed)
		else:
			output.material_to_output = true
			material.is_moving = false
			material.at_exit_node = true


func _get_output(material: RawMaterial):
	for output in outputs:
		if output.connection != null and material in output.get_overlapping_bodies():
			return output
	return null
