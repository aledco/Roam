class_name OutputNode extends InOutNode

func has_material_to_output() -> bool:
	for material in get_overlapping_bodies():
		if material.at_exit_node:
			return true
	return false
