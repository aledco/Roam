class_name Wire extends Line2D

var input: Structure
var output: Structure

var energy := 0

var is_connecting = false

func start_connecting(input: Structure, node_pos: Vector2):
	self.input = input
	is_connecting = true
	add_point(node_pos)
	add_point(to_local(get_global_mouse_position()))

func _process(delta):
	if is_connecting:
		points[1] = to_local(get_global_mouse_position())
