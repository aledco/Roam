class_name PowerNode extends Structure

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_connection_node: Node2D = $EnergyConnectionNode
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var input_wires: Array[Wire] = []
var output_wires: Array[Wire] = []
var current_output_index := 0

var can_connect := false

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE


func set_grid_position(grid_index: Vector2i) -> bool:
	if structure_manager.can_place_structure(grid_index, get_grid_size(), direction):
		var grid_position := grid_index * 32
		global_position = StructureManager.get_structure_position(grid_position, get_grid_size(), direction)
		return true
	else:
		return false

func can_accept_wire_connection() -> bool:
	return can_connect

func get_wire_connection_position() -> Vector2:
	return energy_connection_node.global_position

func connect_wire(wire: Wire):
	can_connect = true
	input_wires.append(wire)
	wire.on_destroyed.connect(func(): Helpers.remove(input_wires, wire))

func send_energy(energy_sent: int):
	for wire in output_wires:
		if wire.is_connected:
			var wire_energy_needed = wire.energy_needed()
			if energy_sent > wire_energy_needed:
				wire.send_energy(wire_energy_needed)
				energy_sent -= wire_energy_needed
			else:
				wire.send_energy(energy_sent)
				energy_sent = 0

func energy_needed():
	var needed := 0
	for wire in output_wires:
		if wire.is_connected:
			needed += wire.energy_needed()
	return needed

func _get_curent_output() -> Wire:
	if output_wires.is_empty():
		return null
	
	if current_output_index >= len(output_wires):
		current_output_index = 0
	
	var start = current_output_index
	while not output_wires[current_output_index].is_connected:
		current_output_index = (current_output_index + 1) %  len(output_wires)
		if current_output_index == start:
			return null
	
	var wire = output_wires[current_output_index]
	return wire

func create_next_wire():
	var wire = WIRE.instantiate() as Wire
	add_child(wire)
	wire.start_connecting(self, energy_connection_node.position)
	output_wires.append(wire)
	wire.on_destroyed.connect(func(): Helpers.remove(output_wires, wire))

func _create_special_ui():
	if not can_connect:
		return false
	
	create_next_wire()
