class_name NaturalStructure extends Structure

const SAW_ROBOT = preload("res://robots/saw_robot/saw_robot.tscn")
const DRILL_ROBOT = preload("res://robots/drill_robot/drill_robot.tscn")
const OUTPUT_NODE = preload("res://structures/in_out_node/output_node/output_node.tscn")

@export var variant_id: int = 1

var time: float = 2.0
var interval_id: int = -1

var outputs_node: Node2D
var current_output_index = 0

var robot: Node2D

var is_player_mining: bool = false
var is_robot_mining: bool = false

func _get_production_material_id() -> int:
	return -1

func get_robot_position() -> Vector2:
	return Vector2.ZERO

func _get_number_of_variants() -> int:
	return 1

func get_player_position() -> Vector2:
	return to_global(get_robot_position())

func begin_player_mining():
	is_player_mining = true
	interval_id = Clock.interval(2.0, _produce_material.bind())

func end_player_mining():
	is_player_mining = false
	Clock.remove_interval(interval_id)
	interval_id = -1

func destroy():
	if interval_id != -1:
		Clock.remove_interval(interval_id)
	super.destroy()


func _place_robot():
	_create_outputs()
	
	if _can_saw():
		robot = SAW_ROBOT.instantiate() as Node2D
	elif _can_drill():
		robot = DRILL_ROBOT.instantiate() as Node2D
	
	add_child(robot)
	robot.set_position(get_robot_position())
	
	if interval_id != -1:
		Clock.remove_interval(interval_id)
	interval_id = Clock.interval(time, _produce_material.bind())
	
	is_robot_mining = true


func _remove_robot():
	is_robot_mining = false
	
	structure_manager.disconnect_outputs(self)
	for output in outputs:
		output.queue_free()
	outputs.clear()
	
	outputs_node.queue_free()
	robot.queue_free()
	Clock.remove_interval(interval_id)


func _create_output(x: int, y: int, angle: float, position: Vector2):
	var output = OUTPUT_NODE.instantiate() as OutputNode
	outputs_node.add_child(output)
	output.position = position
	output.setup(self, Vector2i(x, y), angle)
	outputs.append(output)


func _create_outputs():
	outputs_node = Node2D.new()
	add_child(outputs_node)
	outputs_node.name = "Outputs"
	
	var grid_index = get_grid_index()
	var grid_size = get_grid_size()
	
	# TODO if any larger structures are added, this code will probably break
	for x in range(grid_size.x):
		_create_output(x, 0, PI, Vector2(x * 32, -16 * grid_size.y))
		_create_output(x, grid_size.y - 1, 0, Vector2(x * 32, (grid_size.y-1) * 16 + 16))

	for y in range(grid_size.y):
		_create_output(0, y, PI/2, Vector2(-16, y * 32 - 16 * (grid_size.y-1)))
		_create_output(grid_size.x - 1, y, -PI/2, Vector2((grid_size.x-1) * 32 + 16, y * 32 - 16 * (grid_size.y-1)))
	
	structure_manager.update_structure_outputs(self)


func _produce_material():
	if is_player_mining:
		var material = RawMaterialManager.instantiate_material(_get_production_material_id())
		material_node.add_child(material)
		material.global_position = global_position
		material.add_to_player_inventory()
	elif is_robot_mining:
		var start_index = current_output_index
		while not outputs[current_output_index].connection or outputs[current_output_index].connection.is_full():
			current_output_index = (current_output_index + 1) % len(outputs)
			if current_output_index == start_index:
				return
		
		var output = outputs[current_output_index]
		if output.connection and not output.connection.is_full():
			
			var material = RawMaterialManager.instantiate_material(_get_production_material_id())
			
			var connected_structure = output.get_connected_structure()
			if connected_structure.can_accept_material(material):
				material.parent_structure = self
				material_node.add_child(material)
				material.global_position = output.global_position
				connected_structure.add_material(material)
			else:
				material.free()
		
		current_output_index = (current_output_index + 1) % len(outputs)

func _get_robot_model() -> StructureModel:
	if _can_drill():
		return StructureModel.create("Drill", [[Robot.MATERIAL_ID, 1]], null, preload("res://robots/drill_robot/drill_robot_display.png"), _place_robot.bind())
	if _can_saw():
		return StructureModel.create("Saw", [[Robot.MATERIAL_ID, 1]], null, preload("res://robots/saw_robot/saw_robot_display.png"), _place_robot.bind())
	return null

func _create_special_ui():
	if _can_saw():
		player.saw(self)
	elif _can_drill():
		player.drill(self)
