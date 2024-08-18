class_name TunnelIn extends Conveyor

static var TUNNEL_COST := [
	[IronIngot.MATERIAL_ID, 1], 
	[StoneBrick.MATERIAL_ID, 1]
]

var tunnel_out: TunnelOut

func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, 0)


func set_tunnel_out(tunnel: TunnelOut):
	tunnel_out = tunnel


func add_material(material: RawMaterial):
	on_material_enter(material)
	paths[path_index].add_child(material.mock_follow_node)
	path_index = (path_index + 1) % paths.size()

func on_material_enter(material: RawMaterial):
	super.on_material_enter(material)
	material.start_tunnel()

func on_material_exit(material: RawMaterial):
	material.toggle_underground(true)
	super.on_material_exit(material)

func produce():
	if materials.size() == 0:
		return
	
	for output in outputs:
		if output.connection != null and output.material_to_output:
			if output.connection.is_full():
				continue
			
			var connected_structure = output.get_connected_structure()
			if not connected_structure.can_accept_material(materials[0]):
				continue
			
			var material = materials.front()
			on_material_exit(material)
			connected_structure.add_material(material)
			output.material_to_output = false
