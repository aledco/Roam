class_name BuildUI extends BaseUI

@onready var main_container: Container = $Control/ScrollContainer
@onready var container: Container = $Control/ScrollContainer/Container

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

func get_size() -> Vector2:
	return main_container.size


func create_structure_selections(structures: Array[StructureModel]) -> void:
	for structure in structures:
		_create_structure_ui(structure)


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
