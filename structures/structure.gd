class_name Structure extends StaticBody2D


signal on_destroyed

var structure_manager: StructureManager:
	get:
		return get_node("/root/World/StructureManager") as StructureManager

var player: Player:
	get: 
		return get_node("/root/World/Player") as Player

var material_node: Node2D:
	get: 
		return get_node("/root/World/Materials")


const BUILD_MENU = preload("res://ui/structure_menu/structure_build_menu/structure_build_menu.tscn")

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

func send_energy():
	pass

# END abstract functions


func _ready():
	pass

func destroy():
	on_destroyed.emit()
	for material in Helpers.valid(materials):
		material.queue_free()
	queue_free()

func _process(delta):
	produce()


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
			if StructureManager.get_delete_mode():
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
