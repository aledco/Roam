class_name InputNode extends InOutNode

var path: Path2D

func is_full() -> bool:
	for body in get_overlapping_bodies():
		if body in parent_structure.materials:
			return true
	return false
