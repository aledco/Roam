class_name Building extends MultiInputPathedStructure

const CONVEYOR_PIECE = preload("res://structures/conveyors/conveyor_piece/conveyor_piece.tscn")

var materials_for_output: Array[RawMaterial] = []
var current_output_index = 0

var conveyor_pieces = {}

### BEGIN abstract functions
func _play_default_animation():
	pass

func _play_operate_animation():
	pass

func _get_conveyor_piece_reference_position() -> Vector2:
	return Vector2(0, 15)

func _process_material_in_building(material: RawMaterial, processed_materials: Array[RawMaterial]):
	pass

func _process_materials_in_building(processed_materials: Array[RawMaterial], operational_outputs: Array[OutputNode]):
	pass

### END abstract functions

func can_accept_material(material: RawMaterial):
	var operational_outputs = _get_operational_outputs()
	if len(operational_outputs) == 0:
		return false
	
	if operational_outputs.all(func(output): return output.connection.is_full()):
		return false
	
	return true


func on_input_connected_to(input: InputNode):
	var conveyor_piece = CONVEYOR_PIECE.instantiate() as Node2D
	add_child(conveyor_piece)
	var pos := _get_conveyor_piece_reference_position().rotated(input.angle + PI)
	conveyor_piece.position = pos
	conveyor_piece.rotate(input.angle)
	conveyor_pieces[input] = conveyor_piece

func on_output_connected_to(output: OutputNode):
	var conveyor_piece = CONVEYOR_PIECE.instantiate() as Node2D
	add_child(conveyor_piece)
	var pos := _get_conveyor_piece_reference_position().rotated(output.angle)
	conveyor_piece.position = pos
	conveyor_piece.rotate(output.angle)
	conveyor_pieces[output] = conveyor_piece

func on_input_disconnected(input: InputNode):
	conveyor_pieces[input].queue_free()
	conveyor_pieces.erase(input)

func on_output_disconnected(output: OutputNode):
	conveyor_pieces[output].queue_free()
	conveyor_pieces.erase(output)

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
	_setup_io()


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
		_play_default_animation()
		return
	
	_play_operate_animation()
	
	var operational_outputs = _get_operational_outputs()
	var processed_materials: Array[RawMaterial] = []
	for material in materials:
		if material in materials_for_output:
			continue
		if material.mock_follow_node.progress_ratio == 1:
			_process_material_in_building(material, processed_materials)
	
	_process_materials_in_building(processed_materials, operational_outputs)
	
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


func _get_operational_outputs() -> Array[OutputNode]:
	return outputs.filter(func(output): return output.connection != null)

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

func _get_output(material: RawMaterial):
	var operational_outputs = outputs.filter(func(output): return output.connection != null)
	for output in operational_outputs:
		if material in output.get_overlapping_bodies():
			return output
	return null
