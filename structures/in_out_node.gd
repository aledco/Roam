class_name InOutNode extends Object

var parent: Structure
var local_index: Vector2i
var angle: float

var connection: InOutNode = null
var material_to_output: bool = false

static func create(parent: Structure, local_index: Vector2i, angle: float) -> InOutNode:
	var node := InOutNode.new()
	node.parent = parent
	node.local_index = local_index
	node.angle = angle
	return node


func get_direction() -> Vector2i:
	var direction := Vector2(parent.direction).rotated(angle)
	return Vector2i(direction)


func get_connected_structure() -> Structure:
	if connection == null:
		return null
	return connection.parent
