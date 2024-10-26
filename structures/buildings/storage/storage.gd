class_name Storage extends Building

static var COST := [[Box.MATERIAL_ID, 5], [IronIngot.MATERIAL_ID, 5]]

const OUTPUT_SELECT = preload("res://structures/buildings/storage/output_select/output_select.tscn")

@onready var storage_inventory_menu: StorageInventoryMenu = $StorageInventoryMenu
@onready var storage_inventory: Inventory = storage_inventory_menu.get_storage_inventory()

var output_selects := {}

static var GRID_SIZE: Vector2i = Vector2i(1, 1)
func get_grid_size() -> Vector2i:
	return GRID_SIZE

func _ready():
	super._ready()
	material_added.connect(_on_material_added)

func _on_material_added(material: RawMaterial):
	for output in output_selects:
		output_selects[output].update()


func can_accept_material(material: RawMaterial):
	if storage_inventory.is_full(material.get_material_id()):
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
	storage_inventory_menu.show()

func _process_material_in_building(material: RawMaterial):
	storage_inventory.add_material(material)
	Helpers.remove_and_free(materials, material)

func get_stored_material_ids() -> Array:
	return storage_inventory.get_stored_material_ids()

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

func _get_interval_time() -> float:
	return 2.0

func _timed_action():
	var operational_outputs = _get_operational_outputs()
	if len(operational_outputs) == 0:
		return
	
	var output := get_next_output(operational_outputs)
	if not output:
		return
		
	var output_select := output_selects[output] as OutputSelect
	var material_id := output_select.current_material.material_id
	var success := storage_inventory.remove_material(material_id)
	if not success:
		return
	
	var material = RawMaterialManager.instantiate_material(material_id)
	material_node.add_child(material)
	material.parent_structure = self
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	material.disable_collision()
	output.path.add_child(material.mock_follow_node)
	material.global_position = material.mock_follow_node.global_position
	materials_for_output.append(material)
	materials.append(material)
