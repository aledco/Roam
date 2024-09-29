class_name WaterWheel extends Structure

static var COST := [[Plank.MATERIAL_ID, 10]]

static var GRID_SIZE: Vector2i = Vector2i(2, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_output_node: Node2D = $EnergyOutputNode

var energy := 0
var output_wires: Array[Wire] = []
var interval_id := -1

func _ready():
	super._ready()
	interval_id = Clock.interval(1.0, _produce_energy)

func _get_energy_rate() -> int:
	return 2

func _get_max_energy_stored() -> int:
	return 4

func produce():
	for wire in Helpers.valid(output_wires):
		if wire.is_connected:
			var wire_energy_needed = wire.energy_needed()
			if energy > wire_energy_needed:
				wire.send_energy(wire_energy_needed)
				energy -= wire_energy_needed
			else:
				wire.send_energy(energy)
				energy = 0
	super.produce()

func _create_special_ui():
	var wire = WIRE.instantiate() as Wire
	add_child(wire)
	wire.start_connecting(self, energy_output_node.position)
	wire.on_destroyed.connect(func(): Helpers.remove(output_wires, wire))
	output_wires.append(wire)

func _produce_energy():
	energy += _get_energy_rate()
	if energy > _get_max_energy_stored():
		energy = _get_max_energy_stored()
