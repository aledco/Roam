class_name Structure extends StaticBody2D

const BUILD_MENU = preload("res://ui/structure_menu/structure_build_menu/structure_build_menu.tscn")

signal on_destroyed
signal material_added(material: RawMaterial)
signal material_removed(material: RawMaterial)

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager
@onready var player := get_node("/root/World/Player") as Player
@onready var material_node := get_node("/root/World/Materials") as Node2D

var materials: Array[RawMaterial] = []
var inputs: Array[InputNode] = []
var outputs: Array[OutputNode] = []

var direction := Vector2i(0, 1)

var _input_disabled: bool = false

# BEGIN abstract functions
func _is_placeholder() -> bool:
	return false

func _get_build_list() -> Array[StructureModel]:
	return []

func get_grid_size() -> Vector2i:
	return Vector2i.ZERO

func can_accept_material(material: RawMaterial) -> bool:
	return true

func produce():
	pass

func add_material(material: RawMaterial):
	pass

func _create_special_ui():
	pass

func _can_saw() -> bool:
	return false

func _can_drill() -> bool:
	return false

func on_input_connected_to(input: InputNode):
	pass

func on_output_connected_to(output: OutputNode):
	pass

func on_input_disconnected(input: InputNode):
	pass
 
func on_output_disconnected(output: OutputNode):
	pass

func can_accept_wire_connection() -> bool:
	return false

func get_wire_connection_position() -> Vector2:
	return Vector2.ZERO

func connect_wire(wire: Wire):
	pass

func send_energy(energy: int):
	pass

func energy_needed() -> int:
	return 0

## Override this method to prevent materials from being picked up while owned by the structure.
func are_materials_grabable() -> bool:
	return true
# END abstract functions


func _ready():
	pass

func destroy():
	on_destroyed.emit()
	Helpers.remove_and_free_all(materials)
	queue_free()

func _process(delta):
	produce()

func on_material_enter(material: RawMaterial):
	material.parent_structure = self
	material.mock_follow_node = PathFollow2D.new()
	material.mock_follow_node.loop = false
	materials.push_back(material)
	material_added.emit(material)
	material.destroyed.connect(_on_material_destroyed)

func on_material_exit(material: RawMaterial):
	if material.destroyed.is_connected(_on_material_destroyed):
		material.destroyed.disconnect(_on_material_destroyed)
	Helpers.remove(materials, material)
	material.at_exit_node = false
	if material.mock_follow_node and is_instance_valid(material.mock_follow_node):
		material.mock_follow_node.queue_free()
		material.mock_follow_node = null
	material_removed.emit(material)

## Called when a material owned by the structure is destroyed. Do not touch
## any properties on the material as it has been freed.
func _on_material_destroyed(material: RawMaterial):
	Helpers.remove(materials, material)

func _create_build_ui():
	var build_list := _get_build_list()
	if build_list == []:
		return
	
	var build_ui := BUILD_MENU.instantiate() as StructureBuildMenu
	add_child(build_ui)
	build_ui.create_structure_selections(build_list)


func delay_input():
	_input_disabled = true
	Clock.invoke(0.5, func(): _input_disabled = false)


func _input_event(viewport, event, shape_idx):
	if _is_placeholder() or _input_disabled or player.is_busy():
		return
	
	if event is InputEventMouseButton:
		SignalManager.structure_clicked.emit(self)
		if event.is_action_released("left_click"):
			if player.is_deleting_structure:
				structure_manager.remove_structure(self)
			else:
				_create_build_ui()
		elif event.is_action_released("right_click"):
			_create_special_ui()


func get_grid_index() -> Vector2i:
	"""
	Gets the top left index of the structure.
	"""
	return StructureManager.get_grid_index(self)


func set_direction(new_direction: Vector2i):
	var angle := Vector2(direction).angle_to(Vector2(new_direction))
	rotate(angle)
	direction = new_direction


func has_input() -> bool:
	return inputs.size() > 0


func has_output() -> bool:
	return outputs.size() > 0
