class_name Wire extends Line2D

const BLACK := Color(0, 0, 0, 255)
const RED := Color(2, 0, 0, 2)

const MAX_LENGTH = 5

signal on_destroyed

@onready var power_node: PowerNode = $PowerNode

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var player := get_node("/root/World/Player") as Player

var input: Structure
var output: Structure

var energy := 0

var is_connecting := false
var connecting_structure: Structure

var is_connected := false

func send_energy():
	output.send_energy()

func _destroy_on_input(_input_type):
	if is_connecting:
		destroy()

func destroy():
	on_destroyed.emit()
	player.is_placing_wire = false
	player.set_placing_wire_delayed(false)
	if is_connected:
		WireManager.remove_connection(input, output)
	queue_free()

func start_connecting(input: Structure, node_pos: Vector2):
	self.input = input
	input.on_destroyed.connect(destroy)
	
	is_connecting = true
	player.is_placing_wire = true
	player.set_placing_wire_delayed(true)
	add_point(node_pos)
	add_point(to_local(get_global_mouse_position()))
	SignalManager.player_input.connect(_destroy_on_input)


func _process(delta):
	if is_connecting:
		_set_wire_end()

func _input(event):
	if not is_connecting:
		return
	
	if event is InputEventMouseButton:
		if event.is_action_released("right_click"):
			if not connecting_structure:
				return
			
			output = connecting_structure
			if connecting_structure == power_node:
				structure_manager.add_structure(power_node, true)
				power_node.show()
				_connect(true)
			else:
				power_node.queue_free()
				_connect(false)


func _connect(is_power_node: bool):
	output.on_destroyed.connect(destroy)
	output.connect_wire(self)
	WireManager.add_connection(input, output)
	is_connecting = false
	is_connected = true
	player.set_placing_wire_delayed(false)
	SignalManager.player_input.disconnect(_destroy_on_input)
	if is_power_node:
		power_node.create_next_wire()


func _invalid_end():
	connecting_structure = null
	points[1] = to_local(get_global_mouse_position())
	default_color = RED
	
func _set_wire_end():
	var start_grid_index = input.get_grid_index()
	var end_grid_index := structure_manager.get_mouse_grid_index()
	if start_grid_index == end_grid_index or Vector2(start_grid_index).distance_to(end_grid_index) > MAX_LENGTH:
		power_node.hide()
		_invalid_end()
		return
	
	var success := power_node.set_grid_position(end_grid_index)
	if success:
		power_node.show()
		connecting_structure = power_node
		points[1] = to_local(power_node.energy_connection_node.global_position)
		default_color = BLACK
	else:
		power_node.hide()
		var structure := structure_manager.get_structure_at(end_grid_index)
		if not structure or not structure.can_accept_wire_connection() or WireManager.connected(input, structure):
			_invalid_end()
		else:
			connecting_structure = structure
			points[1] = to_local(structure.get_wire_connection_position())
			default_color = BLACK
