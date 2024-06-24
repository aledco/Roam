class_name TunnelOut extends Conveyor

@onready var material_sensor: Area2D = $MaterialSensor

var tunnel_in: TunnelIn

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, 0)


func produce():
	if materials.size() == 0:
		return
	
	for output in outputs:
		if output.connection != null and output.material_to_output:
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			var material = materials.pop_front()
			material.finish_tunnel()
			material.at_exit_node = false
			connected_structure.add_material(material)
			output.material_to_output = false


func _process(delta):
	super._process(delta)
	for material in material_sensor.get_overlapping_bodies():
		material.toggle_underground(false)


func set_tunnel_in(tunnel: TunnelIn):
	tunnel_in = tunnel
	tunnel_in.set_tunnel_out(self)
	inputs[0].set_position(tunnel_in.outputs[0].position)
