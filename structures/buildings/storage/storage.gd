class_name Storage extends Building

const OUTPUT_SELECT = preload("res://structures/buildings/storage/output_select/output_select.tscn")

@onready var storage_ui: StorageUI = $StorageUI

var output_selects := {}
var interval_id := -1
var time := 2.0

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _ready():
	super._ready()
	interval_id = Clock.interval(time, _produce_material.bind())


func can_accept_material(material: RawMaterial):
	if storage_ui.is_full(material.get_material_id()):
		return false
	return true

func on_output_connected_to(output: OutputNode):
	super.on_output_connected_to(output)
	
	var output_select = OUTPUT_SELECT.instantiate() as OutputSelect
	add_child(output_select)
	var pos := (_get_conveyor_piece_reference_position() - Vector2(0, 2)).rotated(output.angle)
	output_select.position = pos
	output_select.setup(self)
	output_selects[output] = output_select

func on_output_disconnected(output: OutputNode):
	super.on_output_disconnected(output)
	
	output_selects[output].queue_free()
	output_selects.erase(output)

func _create_special_ui():
	storage_ui.show()

func _process_material_in_building(material: RawMaterial, processed_materials: Array[RawMaterial]):
	storage_ui.add_material(material)
	materials.remove_at(materials.find(material))
	material.queue_free()

func _process_materials_in_building(processed_materials: Array[RawMaterial], operational_outputs: Array[OutputNode]):
	pass

func get_stored_material_ids() -> Array:
	return storage_ui.get_stored_material_ids()

func get_next_output(operational_outputs: Array[OutputNode]) -> OutputNode:
	if current_output_index >= len(operational_outputs):
		current_output_index = 0
	
	var start = current_output_index
	while operational_outputs[current_output_index] not in output_selects \
			or not output_selects[operational_outputs[current_output_index]].current_material \
			or operational_outputs[current_output_index].connection.is_full():
		current_output_index = (current_output_index + 1) % len(operational_outputs)
		if current_output_index == start:
			return null
		
	var output = operational_outputs[current_output_index]
	current_output_index = (current_output_index + 1) % len(operational_outputs)
	return output

func _produce_material():
	var operational_outputs = _get_operational_outputs()
	if len(operational_outputs) == 0:
		return
	
	var output := get_next_output(operational_outputs)
	if not output:
		return
		
	var output_select := output_selects[output] as OutputSelect
	var material_id := output_select.current_material.material_id
	var success := storage_ui.remove_material(material_id)
	if not success:
		return
	
	var material = RawMaterialManager.instantiate_material(material_id)
	material_node.add_child(material)
	material.parent = self
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	material.parent = self
	material.disable_collision()
	output.path.add_child(material.mock_follow_node)
	material.global_position = material.mock_follow_node.global_position
	materials_for_output.append(material)
	materials.append(material)
