class_name InOutNode extends Area2D

var parent_structure: Structure
var local_index: Vector2i
var angle: float

var connection: InOutNode

var can_connect: bool = true

func setup(parent_structure: Structure, local_index: Vector2i, angle: float):
	self.parent_structure = parent_structure
	self.local_index = local_index
	self.angle = angle


func set_connection(node: InOutNode):
	connection = node


func get_direction() -> Vector2i:
	var direction := Vector2(parent_structure.direction).rotated(angle)
	return Vector2i(direction)


func get_connected_structure() -> Structure:
	if connection == null:
		return null
	return connection.parent_structure
