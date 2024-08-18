class_name TunnelOutPlaceholder extends ConveyorPlaceholder

const MAX_TUNNEL_DISTANCE = 5

var tunnel_node: Node2D
var tunnel_in: TunnelIn


func _get_structure() -> Resource:
	return preload("res://structures/conveyors/tunnel/out/tunnel_out.tscn")


func _can_rotate() -> bool:
	return false

func _destroy_after_placement() -> bool:
	return true

func destroy():
	if not has_placed:
		structure_manager.remove_structure(tunnel_in, true)
	super.destroy()

func _create_structure_from_placeholder() -> Structure:
	var structure := _get_structure().instantiate() as TunnelOut
	tunnel_node.add_child(structure)
	structure.set_position(position)
	structure.set_direction(direction)
	structure.set_tunnel_in(tunnel_in)
	structure_manager.add_tunnel(tunnel_node)
	return structure


func calculate_position():
	var grid_position := get_grid_position()
	var tunnel_in_grid_position = Vector2(tunnel_in.get_grid_index() * 32)
	var mult = Vector2(abs(tunnel_in.direction))
	var offset = tunnel_in_grid_position * Vector2(mult.y, mult.x)
	if _sum_vec(grid_position * Vector2(tunnel_in.direction)) <= _sum_vec(tunnel_in_grid_position * Vector2(tunnel_in.direction)):
		grid_position = (tunnel_in_grid_position * mult + Vector2(tunnel_in.direction * 32)) + offset
		var index = Vector2i(grid_position / 32)
		var i = 32
		grid_position = (tunnel_in_grid_position * mult + Vector2(tunnel_in.direction * i)) + offset
	else:
		grid_position = grid_position * mult + offset
	var grid_index = Vector2i(grid_position / 32)
	_is_valid = structure_manager.can_place_structure(grid_index, get_grid_size())
	position = StructureManager.get_structure_position(grid_position, get_grid_size(), direction)


func _process(delta):
	calculate_position()
	_set_valid_overlay()

func _sum_vec(vec: Vector2):
	return vec.x + vec.y

func is_valid():
	if not super.is_valid():
		return false
	
	var grid_index = get_grid_index()
	var tunnel_in_index = tunnel_in.get_grid_index()
	var distance = Vector2(grid_index).distance_to(Vector2(tunnel_in_index))
	return distance <= MAX_TUNNEL_DISTANCE
