class_name StructureBuildMenu extends BaseUI

@onready var container: Container = $Control/PanelContainer/ScrollContainer/MarginContainer/Container

const STRUCTURE_SELECT = preload("res://ui/shared/structure_select/structure_select.tscn")

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, get_root_control().size)


func create_structure_selections(structures: Array[StructureModel]) -> void:
	for structure in structures:
		_create_structure_ui(structure)

func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_SELECT.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
