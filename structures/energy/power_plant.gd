class_name PowerPlant extends PathedStructure

const WIRE = preload("res://structures/energy/wire/wire.tscn")

@onready var energy_output_node: Node2D = $EnergyOutputNode
@onready var smoke_node: Node2D = $Smoke
@onready var smoke_array: Array[AnimatedSprite2D] = []

var smoke_animation_active := false

var energy := 0
var output_wires: Array[Wire] = []

func _get_energy_rate() -> int:
	return 0

func _get_max_energy_stored() -> int:
	return 0

func are_materials_grabable() -> bool:
	return false

func _get_fuel_material_id() -> int:
	return -1

func can_accept_material(material: RawMaterial):
	if material.get_material_id() != _get_fuel_material_id():
		return false
	return true

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	inputs[0].path = paths[0]

func _ready():
	super._ready()
	_setup_io()
	if smoke_node:
		for node in smoke_node.get_children():
			smoke_array.append(node as AnimatedSprite2D)

func _play_operate_animation():
	if smoke_node and not smoke_animation_active:
		smoke_animation_active = true
		for smoke in smoke_array:
			smoke.play("smoke")
			if smoke.animation_looped.is_connected(_on_smoke_looped):
				smoke.animation_looped.disconnect(_on_smoke_looped)

func _stop_operate_animation():
	if smoke_animation_active:
		smoke_animation_active = false
		for smoke in smoke_array:
			smoke.animation_looped.connect(_on_smoke_looped)

func _on_smoke_looped():
	for smoke in smoke_array:
		smoke.play("default")
		if smoke.animation_looped.is_connected(_on_smoke_looped):
			smoke.animation_looped.disconnect(_on_smoke_looped)

func produce():
	for material in Helpers.valid(materials):
		if material.mock_follow_node.progress_ratio == 1:
			Helpers.remove_and_free(materials, material)
			energy += _get_energy_rate()
			if energy > _get_max_energy_stored():
				energy = _get_max_energy_stored()
	
	if energy > 0:
		_play_operate_animation()
	else:
		_stop_operate_animation()
	
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
