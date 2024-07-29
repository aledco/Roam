class_name PathedStructure extends Structure

@onready var inputs_node: Node2D = $Inputs
@onready var outputs_node: Node2D = $Outputs
@onready var paths_node: Node2D = $Paths

var paths: Array[Path2D] = []

var path_index: int = 0
var speed: float = 16


func _ready():
	super._ready()
	for node in inputs_node.get_children():
		inputs.append(node as InputNode)
	for node in outputs_node.get_children():
		outputs.append(node as OutputNode)
	for node in paths_node.get_children():
		paths.append(node as Path2D)


## Adds a material to this structures control. The material remains global, but
## this structure is now in control of its movement.
func add_material(material: RawMaterial):
	material.parent = self
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	paths[path_index].add_child(material.mock_follow_node)
	path_index = (path_index + 1) % paths.size()
	materials.push_back(material)


## Produces the material if it is ready and there is an outgoing structure.
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
			
			var material = materials.pop_front()
			material.at_exit_node = false
			connected_structure.add_material(material)
			output.material_to_output = false


func _physics_process(delta):
	for material in materials:
		if not is_instance_valid(material) or material.at_exit_node:
			continue
		
		var output = _get_output(material)
		if output == null:
			material.try_move(delta * speed)
		else:
			output.material_to_output = true
			material.is_moving = false
			material.at_exit_node = true


func _get_output(material: RawMaterial):
	for output in outputs:
		if material in output.get_overlapping_bodies():
			return output
	return null
