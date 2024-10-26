class_name TunnelOut extends Conveyor

@onready var material_sensor: Area2D = $MaterialSensor

var tunnel_in: TunnelIn

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, 0)

func on_material_exit(material: RawMaterial):
	material.finish_tunnel()
	super.on_material_exit(material)

func produce():
	if materials.size() == 0:
		return
	
	for output in outputs:
		if output.connection != null and output.has_material_to_output():
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			if not connected_structure.can_accept_material(materials[0]):
				continue
			
			var material = materials.front()
			on_material_exit(material)
			connected_structure.add_material(material)


func _process(delta):
	super._process(delta)
	for material in material_sensor.get_overlapping_bodies():
		material.toggle_underground(false)


func set_tunnel_in(tunnel: TunnelIn):
	tunnel_in = tunnel
	tunnel_in.set_tunnel_out(self)
	inputs.front().set_position(tunnel_in.outputs.front().position)
	
	var in_point = tunnel_in.paths.front().curve.get_point_position(1)
	var in_point_global = tunnel_in.to_global(in_point)
	var in_point_local = to_local(in_point_global)
	paths.front().curve.set_point_position(0, in_point_local)
