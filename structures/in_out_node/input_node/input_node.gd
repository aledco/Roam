class_name InputNode extends InOutNode

func is_full() -> bool:
	for body in get_overlapping_bodies():
		if body in parent_structure.materials and not body.is_moving:
			return true
	return false
