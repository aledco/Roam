class_name StructureManager extends Node2D

static var _delete_mode: bool
static func set_delete_mode(delete_mode: bool):
	_delete_mode = delete_mode
	if _delete_mode:
		Input.set_custom_mouse_cursor(preload("res://ui/cursor/shovel.png"))
		SignalManager.delete_mode_enabled.emit()
	else:
		Input.set_custom_mouse_cursor(null)
static func get_delete_mode() -> bool:
	return _delete_mode

var structure_map := {}
var tile_map_ids

func create_structure(resource: Resource, grid_index: Vector2i, grid_size: Vector2i):
	var structure = resource.instantiate() as Structure
	add_child(structure)
	var grid_position = get_grid_position(grid_index)
	var structure_position = get_structure_position(grid_position, grid_size)
	structure.set_position(structure_position)
	add_structure(structure)


func _add_structure_to_map(structure: Structure, grid_index: Vector2i):
	var grid_size = structure.get_grid_size()
	for x in range(grid_index.x, grid_index.x + grid_size.x):
		for y in range(grid_index.y, grid_index.y + grid_size.y):
			structure_map[Vector2i(x, y)] = structure


func _remove_structure_from_map(structure: Structure, grid_index: Vector2i):
	var grid_size = structure.get_grid_size()
	for x in range(grid_index.x, grid_index.x + grid_size.x):
		for y in range(grid_index.y, grid_index.y + grid_size.y):
			structure_map.erase(Vector2i(x, y))


func add_structure(structure: Structure):
	add_child(structure)
	var grid_index = structure.get_grid_index()
	_add_structure_to_map(structure, grid_index)
	_connect_structure(structure, grid_index)


func remove_structure(structure: Structure):
	var grid_index = structure.get_grid_index()
	_disconnect_structure(structure, grid_index)
	_remove_structure_from_map(structure, grid_index)
	structure.destroy()


func update_structure_outputs(structure: Structure):
	var grid_index = structure.get_grid_index()
	_connect_outputs(structure, grid_index)


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


func _connect_inputs(structure: Structure, grid_index: Vector2i):
	for input in structure.inputs:
		if not input.can_connect:
			continue
		var prev_index = grid_index + input.local_index - input.get_direction()
		if prev_index in structure_map:
			var prev_structure = structure_map[prev_index]
			for output in prev_structure.outputs:
				if not output.can_connect:
					continue
				var next_index = prev_structure.get_grid_index() + output.local_index + output.get_direction()
				if next_index == grid_index + input.local_index:
					input.connection = output
					output.connection = input
					break


func _connect_outputs(structure: Structure, grid_index: Vector2i):
	for output in structure.outputs:
		if not output.can_connect:
			continue
		var next_index = grid_index + output.local_index + output.get_direction()
		if next_index in structure_map:
			var next_structure = structure_map[next_index]
			for input in next_structure.inputs:
				if not input.can_connect:
					continue
				var prev_index = next_structure.get_grid_index() + input.local_index - input.get_direction()
				if prev_index == grid_index + output.local_index:
					input.connection = output
					output.connection = input
					break


func _connect_structure(structure: Structure, grid_index: Vector2i):
	_connect_inputs(structure, grid_index)
	_connect_outputs(structure, grid_index)


func _disconnect_structure(structure: Structure, grid_index: Vector2i):
	for input in structure.inputs:
		if is_instance_valid(input.connection):
			input.connection.connection = null
	for output in structure.outputs:
		if is_instance_valid(output.connection):
			output.connection.connection = null


func can_place_structure(grid_index: Vector2i, grid_size: Vector2i, invalidate_center: bool = false):
	for x in range(grid_index.x, grid_index.x + grid_size.x):
		for y in range(grid_index.y, grid_index.y + grid_size.y):
			if invalidate_center and x == 0 and y == 0:
				return false
			if Vector2i(x, y) in structure_map or (tile_map_ids != null and Vector2i(x, y) in tile_map_ids and tile_map_ids[Vector2i(x, y)] == 4):
				return false
	return true


static func get_next_grid_multiple(x: Variant) -> Variant:
	match typeof(x):	
		TYPE_VECTOR2:
			return Vector2(get_next_grid_multiple(x.x), get_next_grid_multiple(x.y))
		_:
			return int(x / 32) * 32


static func get_grid_index(position: Vector2, grid_size: Vector2i) -> Vector2i:
	var x := int((position.x - ((grid_size.x  * 32) / 2)) / 32)
	var y := int((position.y - ((grid_size.y  * 32) / 2)) / 32)
	return Vector2i(x, y)

static func get_structure_position(grid_position: Vector2, grid_size: Vector2i) -> Vector2:
	var x := grid_position.x + grid_size.x * 16
	var y := grid_position.y + grid_size.y * 16
	return Vector2(x, y)


static func get_grid_position(grid_index: Vector2i) -> Vector2:
	return Vector2(grid_index * 32)
