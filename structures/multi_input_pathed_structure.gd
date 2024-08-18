class_name MultiInputPathedStructure extends PathedStructure

func add_material(material: RawMaterial):
	on_material_enter(material)
	var input := _get_input(material)
	# sometimes add_material gets called before the input areas are ready, and don't detect the material
	while input == null:
		await get_tree().create_timer(.2).timeout
		if not is_instance_valid(material):
			return
		input = _get_input(material)
	input.path.add_child(material.mock_follow_node)


func _get_input(material: RawMaterial) -> InputNode:
	for input in inputs:
		if material in input.get_overlapping_bodies():
			return input
	return null
