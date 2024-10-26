class_name StructureManager extends Node2D

var player: Player:
	get: 
		return get_node("/root/World/Player") as Player

@onready var structure_node = get_node("/root/World/Structures") as Node2D
@onready var world := get_node("/root/World") as World

var structure_map := {}

## Creates a structure from the structure resource, grid_index, and grid_size.
func create_structure(resource: Resource, grid_index: Vector2i, grid_size: Vector2i):
	var structure = resource.instantiate() as Structure
	var grid_position = grid_index * 32
	var structure_position = get_structure_position(grid_position, grid_size)
	structure.set_position(structure_position)
	add_structure(structure)

## Adds a structure to the structure map.
func _add_structure_to_map(structure: Structure, grid_index: Vector2i):
	var rotated_grid_size = rotate_grid_size(structure.get_grid_size(), structure.direction)
	if Debug.debug_grid():
		print("_add_structure_to_map: rotated_grid_size = ", rotated_grid_size)
	for x in range(grid_index.x, grid_index.x + rotated_grid_size.x, sign(rotated_grid_size.x)):
		for y in range(grid_index.y, grid_index.y + rotated_grid_size.y, sign(rotated_grid_size.y)):
			structure_map[Vector2i(x, y)] = structure
			if Debug.debug_grid():
				print("\t(x, y) = ", Vector2i(x, y))


## Removes a structure from the structure map.
func _remove_structure_from_map(structure: Structure, grid_index: Vector2i):
	var rotated_grid_size = rotate_grid_size(structure.get_grid_size(), structure.direction)
	for x in range(grid_index.x, grid_index.x + rotated_grid_size.x, sign(rotated_grid_size.x)):
		for y in range(grid_index.y, grid_index.y + rotated_grid_size.y, sign(rotated_grid_size.y)):
			structure_map.erase(Vector2i(x, y))


## Adds a structure.
func add_structure(structure: Structure, reparent_structure: bool = false):
	if reparent_structure:
		structure.reparent(structure_node)
	else:
		structure_node.add_child(structure)
	var grid_index = structure.get_grid_index()
	if Debug.debug_grid():
		print("add_structure: ", structure.name, ".grid_index = ", grid_index)
		print("add_structure: ", structure.name, ".grid_size = ", structure.get_grid_size())
		print("add_structure: ", structure.name, ".direction = ", structure.direction)
		print("add_structure: ", structure.name, ".position = ", structure.position)
	_add_structure_to_map(structure, grid_index)
	_connect_structure(structure, grid_index)


## Gets the structure at the provided index.
func get_structure_at(grid_index) -> Structure:
	if grid_index in structure_map:
		return structure_map[grid_index]
	else:
		return null

func _remove_structure(structure: Structure):
	var grid_index = structure.get_grid_index()
	_disconnect_structure(structure)
	_remove_structure_from_map(structure, grid_index)
	structure.destroy()

## Removes a structure.
func remove_structure(structure: Structure, force: bool = false):
	if force or (not structure is TunnelIn and not structure is TunnelOut):
		_remove_structure(structure)
	else:
		var tunnel_node = structure.get_parent()
		var tunnel_in = tunnel_node.get_child(0) as TunnelIn
		var tunnel_out = tunnel_node.get_child(1) as TunnelOut
		_remove_structure(tunnel_in)
		_remove_structure(tunnel_out)	


## Updates the structures outputs.
func update_structure_outputs(structure: Structure):
	var grid_index = structure.get_grid_index()
	_connect_outputs(structure, grid_index)

## Adds a tunnel conveyor. This needs a special function because tunnel input/outputs
## are more complicated than usual.
func add_tunnel(tunnel_node: Node2D):
	var tunnel_in = tunnel_node.get_child(0) as TunnelIn
	var tunnel_out = tunnel_node.get_child(1) as TunnelOut
	var tunnel_in_index = tunnel_in.get_grid_index()
	var tunnel_out_index = tunnel_out.get_grid_index()
	_add_structure_to_map(tunnel_in, tunnel_in_index)
	_add_structure_to_map(tunnel_out, tunnel_out_index)
	_connect_inputs(tunnel_in, tunnel_in_index)
	_connect_outputs(tunnel_out, tunnel_out_index)
	tunnel_in.outputs[0].connection = tunnel_out.inputs[0]
	tunnel_out.inputs[0].connection = tunnel_in.outputs[0]
	tunnel_in.outputs[0].can_connect = false
	tunnel_out.inputs[0].can_connect = false


func remove_tunnel(tunnel_node: Node2D):
	var tunnel_in = tunnel_node.get_child(0) as TunnelIn
	var tunnel_out = tunnel_node.get_child(1) as TunnelOut
	remove_structure(tunnel_in)
	remove_structure(tunnel_out)

func _connect(input: InputNode, output: OutputNode):
	if input.connection != output:
		input.connection = output
		input.parent_structure.on_input_connected_to(input)
	if output.connection != input:
		output.connection = input
		output.parent_structure.on_output_connected_to(output)

## Connects the inputs of a structure to outputs around it.
func _connect_inputs(structure: Structure, grid_index: Vector2i):
	for input in structure.inputs:
		if not input.can_connect:
			continue
		var prev_index = grid_index + input.get_local_index() - input.get_direction()
		if prev_index in structure_map:	
			var prev_structure = structure_map[prev_index]
			for output in prev_structure.outputs:
				if not output.can_connect:
					continue
				var next_index = prev_structure.get_grid_index() + output.get_local_index() + output.get_direction()
				if next_index == grid_index + input.get_local_index():
					if input.is_in_and_out and output.is_in_and_out:
						break
					_connect(input, output)
					break


## Connects the outputs of a structure to inputs around it.
func _connect_outputs(structure: Structure, grid_index: Vector2i):
	for output in structure.outputs:
		if not output.can_connect:
			continue
		var next_index = grid_index + output.get_local_index() + output.get_direction()
		if next_index in structure_map:
			var next_structure = structure_map[next_index]
			for input in next_structure.inputs:
				if not input.can_connect:
					continue
				var prev_index = next_structure.get_grid_index() + input.get_local_index() - input.get_direction()
				if prev_index == grid_index + output.get_local_index():
					if input.is_in_and_out and output.is_in_and_out:
						break
					_connect(input, output)
					break

## Connects a structure to those around it.
func _connect_structure(structure: Structure, grid_index: Vector2i):
	_connect_inputs(structure, grid_index)
	_connect_outputs(structure, grid_index)

func disconnect_inputs(structure: Structure):
	for input in structure.inputs:
		# input.parent_structure.on_input_disconnected(input)
		if is_instance_valid(input.connection):
			input.get_connected_structure().on_output_disconnected(input.connection)
			input.connection.connection = null


func disconnect_outputs(structure: Structure):
	for output in structure.outputs:
		# output.parent_structure.on_output_disconnected(output)
		if is_instance_valid(output.connection):
			output.get_connected_structure().on_input_disconnected(output.connection)
			output.connection.connection = null


## Disconnects a structure from those around it.
func _disconnect_structure(structure: Structure):
	disconnect_inputs(structure)
	disconnect_outputs(structure)


## Determines if a structure with the provided grid size can be placed in the provided
## grid index.
func can_place_structure(grid_index: Vector2i, grid_size: Vector2i, direction: Vector2i = Vector2i(0, 1), indices_allowed_on_water: Array[Vector2i] = []):
	var rotated_grid_size = rotate_grid_size(grid_size, direction)
	var player_indices = get_player_grid_indices()
	for x in range(grid_index.x, grid_index.x + rotated_grid_size.x, sign(rotated_grid_size.x)):
		for y in range(grid_index.y, grid_index.y + rotated_grid_size.y, sign(rotated_grid_size.y)):
			var curr_grid_index := Vector2i(x, y)
			if curr_grid_index in structure_map \
					or _on_water_illegally(curr_grid_index, indices_allowed_on_water) \
					or curr_grid_index in player_indices:
				return false
	return true

func _on_water_illegally(current_grid_index: Vector2i, indices_allowed_on_water: Array[Vector2i]):
	if world.is_water_tile(current_grid_index):
		return current_grid_index not in indices_allowed_on_water
	return false

func get_player_grid_indices() -> Array[Vector2i]:
	var indices: Array[Vector2i] = []
	
	var top_left := player.position + Vector2(-8, -32)
	var top_right := player.position + Vector2(8, -32)
	var bottom_left := player.position + Vector2(-8, 0)
	var bottom_right := player.position + Vector2(8, 0)
	
	var crossing_right := int(bottom_right.x) % 32 != 0
	var crossing_down := int(bottom_right.y) % 32 != 0
	
	indices.append(get_grid_index_of_position(top_left))
	if crossing_right:
		indices.append(get_grid_index_of_position(top_right))
	if crossing_down:
		indices.append(get_grid_index_of_position(bottom_left))
	if crossing_right and crossing_down:
		indices.append(get_grid_index_of_position(bottom_right))
	return indices

## Gets the grid index of the mouse.
func get_mouse_grid_index() -> Vector2i:
	var mouse_pos = get_global_mouse_position()
	return get_grid_index_of_position(mouse_pos)


## Gets the next multiple of 32.
static func get_next_grid_multiple(x: Variant) -> Variant:
	match typeof(x):	
		TYPE_VECTOR2:
			return Vector2(get_next_grid_multiple(x.x), get_next_grid_multiple(x.y))
		_:
			return int(x / 32) * 32


## Gets the grid index of any position. 
static func get_grid_index_of_position(pos: Vector2) -> Vector2i:
	var round_down = func(x: int):
		var r = abs(x) % 32
		if r == 0:
			return x
		
		if x < 0:
			return -(abs(x) - abs(r) + 32)
		else:
			return x - r

	return Vector2i(round_down.call(int(pos.x)) / 32, round_down.call(int(pos.y)) / 32)


## Gets the grid index of a structure, taking the structures direciton into account.
## The grid index of a structure is the index of the grid cell that the unrotated top left
## corner of the structure occupies.
static func get_grid_index(structure: Structure) -> Vector2i:
	var grid_position = get_grid_position(structure.position, structure.get_grid_size(), structure.direction)
	return Vector2i(grid_position / 32)


## Gets the structure position from the grid position.
## Structure position is the actual position of the structure, while grid position is just
## the grid index multiplied by 32. Takes the structures rotation into account.
static func get_structure_position(grid_position: Vector2, grid_size: Vector2i, direction: Vector2i = Vector2i(0, 1)) -> Vector2:
	var x := grid_position.x + grid_size.x * 16
	var y := grid_position.y + grid_size.y * 16
	
	# If the structure is not square and rotated sideways, need to offset position
	if grid_size.y != grid_size.x and direction.x != 0:
		var offset = 16 * (grid_size.y - grid_size.x)
		return Vector2(x + offset, y - offset)
	return Vector2(x, y)


## Gets the grid position from the structure position.
## Undos get_structure_position().
static func get_grid_position(structure_position: Vector2, grid_size: Vector2i, direction: Vector2i = Vector2i(0, 1)) -> Vector2:
	var x := structure_position.x
	var y := structure_position.y
	match direction:
		Vector2i(0, 1):
			x -= grid_size.x * 16
			y -= grid_size.y * 16
		Vector2i(0, -1):
			x += (grid_size.x - 2) * 16
			y += (grid_size.y - 2) * 16
		Vector2i(1, 0):
			x -= grid_size.y * 16
			y += (grid_size.x - 2) * 16
		Vector2i(-1, 0):
			x += (grid_size.y - 2) * 16
			y -= grid_size.x * 16
	return Vector2(x, y)


## Rotates the grid size.
static func rotate_grid_size(grid_size: Vector2i, direction: Vector2i) -> Vector2i:
	match direction:
		Vector2i(0, 1):
			return grid_size
		Vector2i(0, -1):
			return -grid_size
		Vector2i(1, 0):
			return Vector2i(grid_size.y, -grid_size.x)
		Vector2i(-1, 0):
			return Vector2i(-grid_size.y, grid_size.x)
		_: 
			return grid_size

## For debugging only
const GRID_DEBUG_INFO = preload("res://structures/structure_manager/grid_debug_info.tscn")
var debug_info = null
func _process(delta):
	if Debug.debug_grid():
		if debug_info != null:
			debug_info.queue_free()
		
		var mouse_index = get_mouse_grid_index()
		
		var grid_position = mouse_index * 32
		debug_info = GRID_DEBUG_INFO.instantiate()
		add_child(debug_info)
		debug_info.global_position = get_global_mouse_position()
		var label := debug_info.get_child(0) as RichTextLabel
		label.text = "[center]<%s, %s>[/center]" % [mouse_index.x, mouse_index.y]
