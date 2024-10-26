class_name PoweredBuilding extends Building

var input_wires: Array[Wire] = []
var energy := 0

func can_accept_material(material: RawMaterial):
	if not super.can_accept_material(material):
		return false
	
	if energy == 0:
		return false
	return true

func can_accept_wire_connection() -> bool:
	return true

func get_wire_connection_position() -> Vector2:
	return global_position

func connect_wire(wire: Wire):
	input_wires.append(wire)
	wire.on_destroyed.connect(func(): Helpers.remove(input_wires, wire))

func send_energy(energy_sent: int):
	energy += energy_sent

func energy_needed() -> int:
	if energy == 0:
		return 1
	else:
		return 0
