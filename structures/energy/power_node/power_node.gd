class_name PowerNode extends Structure

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_connection_node: Node2D = $EnergyConnectionNode
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var input_wires: Array[Wire] = []
var output_wires: Array[Wire] = []

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

func _create_special_ui():
	if not can_connect:
		return false
	
	var wire = WIRE.instantiate() as Wire
	add_child(wire)
	wire.start_connecting(self, energy_connection_node.position)
	output_wires.append(wire)
