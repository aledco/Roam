class_name Building extends MultiInputPathedStructure

const CONVEYOR_PIECE = preload("res://structures/conveyors/conveyor_piece/conveyor_piece.tscn")

var materials_for_output: Array[RawMaterial] = []
var current_output_index = 0

var at_max_capacity := false

var conveyor_pieces = {}

var interval_id := -1

### BEGIN abstract functions
func _play_default_animation():
	pass

func _play_operate_animation():
	pass

func _get_conveyor_piece_reference_position() -> Vector2:
	return Vector2(0, 15)

func _process_material_in_building(material: RawMaterial):
	pass

func _get_interval_time() -> float:
	return -1

func _timed_action():
	pass

func _get_max_capacity() -> int:
	return -1
### END abstract functions

func are_materials_grabable() -> bool:
	return false

func _on_material_destroyed(material: RawMaterial):
	super. _on_material_destroyed(material)
	Helpers.remove(materials_for_output, material)

func can_accept_material(material: RawMaterial):
	var operational_outputs = _get_operational_outputs()
	if len(operational_outputs) == 0:
		return false
	
	if operational_outputs.all(func(output): return output.connection.is_full()):
		return false
	
	if at_max_capacity:
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
	
	var interval_time := _get_interval_time()
	if interval_time != -1:
		interval_id = Clock.interval(interval_time, _timed_action)

func destroy():
	if interval_id != -1:
		Clock.remove_interval(_get_interval_time(), interval_id)
	super.destroy()

func add_material(material: RawMaterial):
	on_material_enter(material)
	var input := _get_input(material)
	# sometimes add_material gets called before the input areas are ready, and don't detect the material
	while input == null:
		await get_tree().create_timer(0.2).timeout
		if not is_instance_valid(material):
			return
		input = _get_input(material)
	input.path.add_child(material.mock_follow_node)

func on_material_enter(material: RawMaterial):
	super.on_material_enter(material)
	material.disable_collision()

func on_material_exit(material: RawMaterial):
	materials_for_output.remove_at(materials_for_output.find(material))
	material.enable_collision()
	super.on_material_exit(material)

func produce():
	if len(materials) == 0:
		_play_default_animation()
		return
	
	_play_operate_animation()
	
	var operational_outputs = _get_operational_outputs()
	var material_in_center: Array[RawMaterial] = []
	for material in Helpers.valid(materials):
		if material in materials_for_output:
			continue
		if material.mock_follow_node.progress_ratio == 1:
			material_in_center.append(material)
			_process_material_in_building(material)
	
	var max_capacity := _get_max_capacity()
	if max_capacity != -1:
		at_max_capacity = len(material_in_center) > max_capacity

	for output in operational_outputs:
		if output.connection and output.has_material_to_output():
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			var material = _get_material_to_exit(output)
			if not connected_structure.can_accept_material(material):
				continue
			
			on_material_exit(material)
			connected_structure.add_material(material)

func _get_operational_outputs() -> Array[OutputNode]:
	return outputs.filter(func(output): return output.connection != null)

func get_next_output(operational_outputs: Array[OutputNode]) -> OutputNode:
	if len(operational_outputs) == 0:
		return null
	
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
	for material in Helpers.valid(materials_for_output):
		if material.at_exit_node and material in output.get_overlapping_bodies():
			return material

func _get_output(material: RawMaterial):
	var operational_outputs = outputs.filter(func(output): return output.connection != null)
	for output in operational_outputs:
		if material in output.get_overlapping_bodies():
			return output
	return null
