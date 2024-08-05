class_name PowerPlant extends PathedStructure

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_output_node: Node2D = $EnergyOutputNode

var energy := 0

var output_wires: Array[Wire] = []
var current_wire_index := 0

func _get_energy_rate() -> int:
	return 0

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]

func _ready():
	super._ready()
	_setup_io()

func produce():
	for material in Helpers.valid(materials):
		if material.mock_follow_node.progress_ratio == 1:
			Helpers.remove_and_free(materials, material)
			energy += _get_energy_rate()
	
	for wire in Helpers.valid(output_wires):
		if energy == 0:
			break
		if wire.is_connected:
			wire.send_energy()
			energy -= 1

	super.produce()

func _create_special_ui():
	var wire = WIRE.instantiate() as Wire
	add_child(wire)
	wire.start_connecting(self, energy_output_node.position)
	wire.on_destroyed.connect(func(): Helpers.remove(output_wires, wire))
	output_wires.append(wire)
