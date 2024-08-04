class_name PowerPlant extends PathedStructure

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_output_node: Node2D = $EnergyOutputNode

var energy := 0

func _get_energy_rate() -> int:
	return 0

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, PI, true)
	inputs[0].path = paths[0]

func _ready():
	super._ready()
	_setup_io()

func produce():
	if materials.size() == 0:
		return
	
	for material in materials:
		if material.mock_follow_node.progress_ratio == 1:
			materials.remove_at(materials.find(material))
			material.queue_free()
			energy += _get_energy_rate()
	
	super.produce()

func _create_special_ui():
	var wire = WIRE.instantiate() as Wire
	add_child(wire)
	wire.start_connecting(self, energy_output_node.position)
