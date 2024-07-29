class_name Connection extends Object

const INPUT_NODE = preload("res://structures/in_out_node/input_node/input_node.tscn")
const OUTPUT_NODE = preload("res://structures/in_out_node/output_node/output_node.tscn")

var parent_structure: DelayedConnectionStructure
var local_index: Vector2i
var angle: float

static func create(parent_structure: DelayedConnectionStructure, local_index: Vector2i, angle: float) -> Connection:
	var connection = Connection.new()
	connection.parent_structure = parent_structure
	connection.local_index = local_index
	connection.angle = angle
	return connection


func get_input_node() -> InputNode:
	var input_node = INPUT_NODE.instantiate() as InputNode
	input_node.setup(parent_structure, local_index, angle)
	parent_structure.add_input_node(input_node)
	return input_node


func get_output_node() -> OutputNode:
	var output_node = OUTPUT_NODE.instantiate() as OutputNode
	output_node.setup(parent_structure, local_index, angle)
	parent_structure.add_output_node(output_node)
	return output_node


func get_direction() -> Vector2i:
	var direction := Vector2(parent_structure.direction).rotated(angle)
	return Vector2i(direction)


func get_local_index() -> Vector2i:
	match parent_structure.direction:
		Vector2i(0, 1):
			return local_index
		Vector2i(0, -1):
			return -local_index
		Vector2i(1, 0):
			return Vector2i(local_index.y, -local_index.x)
		Vector2i(-1, 0):
			return Vector2i(-local_index.y, local_index.x)
		_:
			return local_index
