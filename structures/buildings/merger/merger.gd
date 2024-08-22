class_name Merger extends PoweredBuilding

static var COST := [[IronIngot.MATERIAL_ID, 10]]

var materials_waiting_for_output: Array[RawMaterial] = []

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func can_accept_material(material: RawMaterial):
	if not super.can_accept_material(material):
		return false
	return true

func _on_material_destroyed(material: RawMaterial):
	super. _on_material_destroyed(material)
	Helpers.remove(materials_waiting_for_output, material)

func _process_material_in_building(material: RawMaterial):
	if material not in materials_waiting_for_output:
		materials_waiting_for_output.append(material)

func _get_max_capacity() -> int:
	return 8

func _get_interval_time() -> float:
	return 1.0

func _timed_action():
	if energy == 0 or len(Helpers.valid(materials_waiting_for_output)) == 0:
		return
	
	var material = Helpers.valid(materials_waiting_for_output)[0]
	Helpers.remove(materials_waiting_for_output, material)
	
	var operational_outputs = _get_operational_outputs()
	if len(operational_outputs) == 0:
		Helpers.remove_and_free(materials, material)
		return
	
	var output := get_next_output(operational_outputs)
	if not output:
		Helpers.remove_and_free(materials, material)
		return
	
	material.mock_follow_node.reparent(output.path)
	material.mock_follow_node.progress_ratio = 0
	materials_for_output.append(material)
	energy -= 1
