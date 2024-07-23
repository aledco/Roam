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
	
	return Vector2i(local_index.y, local_index.x)

func get_connected_structure() -> Structure:
	if connection == null:
		return null
	return connection.parent_structure
