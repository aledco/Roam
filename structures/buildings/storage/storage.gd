class_name Storage extends Building

const OUTPUT_SELECT = preload("res://structures/buildings/storage/output_select/output_select.tscn")

@onready var storage_ui: StorageUI = $StorageUI

var output_selects := {}

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func can_accept_material(material: RawMaterial):
	if storage_ui.is_full(material.get_material_id()):
		return false
	return true

func on_output_connected_to(output: OutputNode):
	super.on_output_connected_to(output)
	
	var output_select = OUTPUT_SELECT.instantiate() as OutputSelect
	add_child(output_select)
	var pos := (_get_conveyor_piece_reference_position()).rotated(output.angle)
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

func get_stored_material_ids() -> Array[int]:
	return storage_ui.get_stored_material_ids()
