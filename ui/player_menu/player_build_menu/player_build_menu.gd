class_name PlayerBuildMenu extends ScrollContainer

const STRUCTURE_SELECT = preload("res://ui/shared/structure_select/structure_select.tscn")

@onready var grid_container: Container = $MarginContainer/GridContainer

func _ready():
	var models := StructurePlaceholder.get_models()
	for model in models:
		var structure_ui = STRUCTURE_SELECT.instantiate()
		grid_container.add_child(structure_ui)
		structure_ui.set_model(model)
		structure_ui.set_root_ui_node(find_parent("PlayerMenu"))
