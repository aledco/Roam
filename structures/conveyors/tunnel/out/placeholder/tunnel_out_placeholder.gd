class_name TunnelOutPlaceholder extends ConveyorPlaceholder

var tunnel_node: Node2D
var tunnel_in: TunnelIn

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/tunnel/out/tunnel_out.tscn")


func _can_rotate() -> bool:
	return false


func _create_structure():
	var structure := _get_structure().instantiate() as TunnelOut
	tunnel_node.add_child(structure)
	structure.set_position(position)
	structure.set_direction(direction)
	structure.set_tunnel_in(tunnel_in)
	structure_manager.add_tunnel(tunnel_node)
	queue_free()


func calculate_position():
	var absolute_position := _calculate_position_from_mouse()
	var grid_position := StructureManager.get_next_grid_multiple(absolute_position) as Vector2
	var tunnel_in_grid_position = StructureManager.get_grid_position(tunnel_in.get_grid_index())
	var mult = Vector2(abs(tunnel_in.direction))
	var offset = tunnel_in_grid_position * Vector2(mult.y, mult.x)
	if _sum_vec(grid_position * Vector2(tunnel_in.direction)) <= _sum_vec(tunnel_in_grid_position * Vector2(tunnel_in.direction)):
		grid_position = (tunnel_in_grid_position * mult + Vector2(tunnel_in.direction * 32)) + offset
		var index = Vector2i(grid_position / 32)
		var i = 32
		while not structure_manager.can_place_structure(index, get_grid_size()):
			grid_position = (tunnel_in_grid_position * mult + Vector2(tunnel_in.direction * i)) + offset
			index = Vector2i(grid_position / 32)
			i += 32
	else:
		grid_position = grid_position * mult + offset
	var grid_index = Vector2i(grid_position / 32)
	if structure_manager.can_place_structure(grid_index, get_grid_size()):
		position = StructureManager.get_structure_position(grid_position, get_grid_size())


func _process(delta):
	calculate_position()


func _sum_vec(vec: Vector2):
	return vec.x + vec.y
