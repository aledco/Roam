class_name Splitter extends Structure

# TODO make more general class that can handle any number of paths

@onready var enter: Area2D = $Enter
@onready var exit_left: Area2D = $ExitLeft
@onready var exit_right: Area2D = $ExitRight
@onready var path_left: Path2D = $Path2DLeft
@onready var path_right: Path2D = $Path2DRight

var speed: float = 32
var path_to_take = 0


func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _ready():
	inputs = [InOutNode.create(self, Vector2i.ZERO, 0)]
	outputs = [InOutNode.create(self, Vector2i.ZERO, PI/2), InOutNode.create(self, Vector2i.ZERO, -PI/2)]


## Adds a material to this structures control. The material remains global, but
## this structure is now in control of its movement.
func add_material(material: RawMaterial):
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	if path_to_take == 0:
		path_left.add_child(material.mock_follow_node)
		path_to_take = 1
	else:
		path_right.add_child(material.mock_follow_node)
		path_to_take = 0
	
	materials.push_back(material)


## Produces the material if it is ready and there is an outgoing structure.
func produce():
	if materials.size() == 0:
		return
	
	for output in outputs:
		if output.connection != null and output.material_to_output:
			var connected_structure = output.get_connected_structure()
			if connected_structure.is_full():
				return

			var material = materials.pop_front()
			material.at_exit_node = false
			connected_structure.add_material(material)
			output.material_to_output = false


## Determines if the structure is full of materials.
func is_full() -> bool:
	for body in enter.get_overlapping_bodies():
		if body in materials:
			return true
	return false


func _physics_process(delta):
	for material in materials:
		if not material.at_exit_node:
			if material in exit_left.get_overlapping_bodies():
				outputs[0].material_to_output = true
				material.at_exit_node = true
			elif material in exit_right.get_overlapping_bodies():
				outputs[1].material_to_output = true
				material.at_exit_node = true
			else:
				material.try_move(delta * speed)
