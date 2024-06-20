class_name MaterialProducer extends SinglePathStructure

# BEGIN abstract functions
func _get_production_material() -> Resource:
	return null
# END abstract functions


func _ready():
	Clock.one_second_timer.connect(_on_one_second.bind())


func add_material(material: RawMaterial):
	material_node.add_child(material)
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	path.add_child(material.mock_follow_node)
	material.global_position = material.mock_follow_node.global_position
	materials.push_back(material)


func _on_one_second():
	if not is_full():
		var material = _get_production_material().instantiate() as RawMaterial
		add_material(material)
