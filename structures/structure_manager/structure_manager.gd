class_name StructureManager extends Node2D

const TREE = preload("res://structures/tree/tree.tscn")

var structure_map := {}

func _ready():
	create_struture(TREE, get_structure_position(Vector2(32, -32), Vector2i(1, 2)))
	create_struture(TREE, get_structure_position(Vector2(-32, -64), Vector2i(1, 2)))


func create_struture(resource: Resource, grid_position: Vector2):
	var structure = resource.instantiate() as Structure
	add_child(structure)
	structure.set_position(grid_position)
	add_structure(structure)


func _add_structure_to_map(structure: Structure, grid_index: Vector2i):
	var grid_size = structure.get_grid_size()
	for x in range(grid_index.x, grid_index.x + grid_size.x):
		for y in range(grid_index.y, grid_index.y + grid_size.y):
			structure_map[Vector2i(x, y)] = structure


func add_structure(structure: Structure):
	var grid_index = structure.get_grid_index()
	_add_structure_to_map(structure, grid_index)
	_connect_structure(structure, grid_index)


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


func can_place_structure(grid_index: Vector2i, grid_size: Vector2i):
	for x in range(grid_index.x, grid_index.x + grid_size.x):
		for y in range(grid_index.y, grid_index.y + grid_size.y):
			if Vector2i(x, y) in structure_map:
				return false
	return true


static func get_next_grid_multiple(x: Variant) -> Variant:
	match typeof(x):	
		TYPE_VECTOR2:
			return Vector2(get_next_grid_multiple(x.x), get_next_grid_multiple(x.y))
		_:
			return int(x / 32) * 32


static func get_structure_position(grid_position: Vector2, grid_size: Vector2i) -> Vector2:
	var x := grid_position.x + grid_size.x * 16
	var y := grid_position.y + grid_size.y * 16
	return Vector2(x, y)


static func get_grid_position(grid_index: Vector2i) -> Vector2:
	return Vector2(grid_index * 32)
