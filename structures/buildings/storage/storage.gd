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
	#if len(operational_outputs) == 0:
		#return
	#
	#var operational_output = get_next_output(operational_outputs)
	#if operational_output == null:
		#return
	#
	#var new_mat := RawMaterialManager.instantiate_material(current_material.material_id)
	#material_node.add_child(new_mat)
	#new_mat.mock_follow_node = PathFollow2D.new()
	#new_mat.mock_follow_node.loop = false
	#new_mat.parent = self
	#new_mat.disable_collision() # TODO skip full outputs
	#operational_output.path.add_child(new_mat.mock_follow_node)
	#new_mat.global_position = new_mat.mock_follow_node.global_position
	#materials_for_output.append(new_mat)
	#materials.append(new_mat)

func get_stored_material_ids() -> Array[int]:
	return storage_ui.get_stored_material_ids()

func _produce_material():
	pass # TODO remove mat from inventory, add to output
