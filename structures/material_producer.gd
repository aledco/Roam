class_name MaterialProducer extends PathedStructure


var input: InputNode
var path: Path2D

var time: float = 2.0
var interval_id: int

# BEGIN abstract functions
func _get_production_material_id() -> int:
	return -1
# END abstract functions


func _ready():
	super._ready()
	
	assert(inputs.size() == 1)
	input = inputs[0]
	inputs.remove_at(0)
	
	assert(paths.size() == 1)
	path = paths[0]
	
	interval_id = Clock.interval(2.0, _produce_material.bind())


func destroy():
	Clock.remove_interval(time, interval_id)
	super.destroy()

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
		var material = RawMaterialManager.instantiate_material(_get_production_material_id())
		add_material(material)
