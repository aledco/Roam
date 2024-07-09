class_name MaterialProducer extends PathedStructure

var input: InputNode
var path: Path2D

# BEGIN abstract functions
func _get_production_material() -> Resource:
	return null
# END abstract functions


func _ready():
	super._ready()
	
	assert(inputs.size() == 1)
	input = inputs[0]
	inputs.remove_at(0)
	
	assert(paths.size() == 1)
	path = paths[0]
	
	Clock.interval(2.0, _produce_material.bind())


func add_material(material: RawMaterial):
	material.parent = self
	material_node.add_child(material)
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	path.add_child(material.mock_follow_node)
	material.global_position = material.mock_follow_node.global_position
	materials.push_back(material)


func _produce_material():
	if not input.is_full():
		var material = _get_production_material().instantiate() as RawMaterial
		add_material(material)
