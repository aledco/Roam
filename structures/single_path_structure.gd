class_name SinglePathStructure extends Structure

@onready var enter: Area2D = $Enter
@onready var exit: Area2D = $Exit
@onready var path: Path2D = $Path2D

var ready_for_production: bool = false
var speed: float = 32

## Adds a material to this structures control. The material remains global, but
## this structure is now in control of its movement.
func add_material(material: RawMaterial):
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	path.add_child(material.mock_follow_node)
	materials.push_back(material)


## Produces the material if it is ready and there is an outgoing structure.
func produce():
	if materials.size() >= 1 and outputs[0].connection != null and outputs[0].material_to_output:
		var connected_structure = outputs[0].get_connected_structure()
		if connected_structure.is_full():
			return

		var material = materials.pop_front()
		material.at_exit_node = false
		connected_structure.add_material(material) # TODO make more elegant
		outputs[0].material_to_output = false


## Determines if the structure is full of materials.
func is_full() -> bool:
	for body in enter.get_overlapping_bodies():
		if body in materials:
			return true
	return false


func _physics_process(delta):
	for material in materials:
		if not material.at_exit_node:
			if material in exit.get_overlapping_bodies():
				outputs[0].material_to_output = true
				material.at_exit_node = true
			else:
				material.try_move(delta * speed)
