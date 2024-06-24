class_name TunnelIn extends Conveyor

var tunnel_out: TunnelOut

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, 0)


func set_tunnel_out(tunnel: TunnelOut):
	tunnel_out = tunnel


func add_material(material: RawMaterial):
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	paths[path_index].add_child(material.mock_follow_node)
	path_index = (path_index + 1) % paths.size()
	material.start_tunnel()
	materials.push_back(material)


func produce():
	if materials.size() == 0:
		return
	
	for output in outputs:
		if output.connection != null and output.material_to_output:
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			var material = materials.pop_front()
			material.toggle_underground(true)
			material.at_exit_node = false
			connected_structure.add_material(material)
			output.material_to_output = false
