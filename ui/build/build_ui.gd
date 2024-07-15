class_name BuildUI extends BaseUI

@onready var main_container: ScrollContainer = $Control/ScrollContainer
@onready var container: Container = $Control/ScrollContainer/Container

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")

func get_rect() -> Rect2:
	return main_container.get_rect()


func create_structure_selections(structures: Array[StructureModel]) -> void:
	for structure in structures:
		_create_structure_ui(structure)
	if len(structures) == 1:
		main_container.set_size(main_container.get_size() * Vector2(1, 0.5) - Vector2(10, 0))
		main_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
