class_name Merger extends Building

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _ready():
	super._ready()


func _process_material_in_building(material: RawMaterial, processed_materials: Array[RawMaterial]):
	processed_materials.append(material)

func _process_materials_in_building(processed_materials: Array[RawMaterial], operational_outputs: Array[OutputNode]):
	for material in processed_materials:
		var output = get_next_output(operational_outputs)
		material.mock_follow_node.reparent(output.path)
		material.mock_follow_node.progress_ratio = 0
		materials_for_output.append(material)
		
