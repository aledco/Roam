class_name MultiInputPathedStructure extends PathedStructure


func add_material(material: RawMaterial):
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	var input := _get_input(material)
	# sometimes add_material gets called before the input areas are ready, and don't detect the material
	while input == null:
		await get_tree().create_timer(.2).timeout
		input = _get_input(material)
	input.path.add_child(material.mock_follow_node)
	materials.push_back(material)


func _get_input(material: RawMaterial) -> InputNode:
	for input in inputs:
		if material in input.get_overlapping_bodies():
			return input
	return null
