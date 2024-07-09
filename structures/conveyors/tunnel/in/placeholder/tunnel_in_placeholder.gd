class_name TunnelInPlaceholder extends ConveyorPlaceholder

const TUNNEL_OUT_PLACEHOLDER = preload("res://structures/conveyors/tunnel/out/placeholder/tunnel_out_placeholder.tscn")

var tunnel_node: Node2D

func _get_structure() -> Resource:
	return preload("res://structures/conveyors/tunnel/in/tunnel_in.tscn")


func _create_structure():
	tunnel_node = Node2D.new()
	get_parent().add_child(tunnel_node)
	tunnel_node.set_position(Vector2.ZERO)
	
	var structure := _get_structure().instantiate() as TunnelIn
	tunnel_node.add_child(structure)
	structure.set_position(position)
	structure.set_direction(direction)

	var tunnel_out_placeholder := TUNNEL_OUT_PLACEHOLDER.instantiate() as TunnelOutPlaceholder
	get_parent().add_child(tunnel_out_placeholder)
	tunnel_out_placeholder.set_direction(direction)
	tunnel_out_placeholder.tunnel_node = tunnel_node
	tunnel_out_placeholder.tunnel_in = structure
	
	queue_free()


static func get_model() -> StructureModel:
	return StructureModel.create(
		null, 
		"Tunnel", 
		1, 
		preload("res://structures/conveyors/tunnel/in/placeholder/tunnel_in_placeholder.tscn"),
		preload("res://structures/conveyors/tunnel/in/tunnel_in.png"))
