class_name MaterialSelectMenu extends BaseUI

@onready var main_container: Container = $Control/TabContainer
@onready var _1: Container = $"Control/TabContainer/1"
@onready var _2: Container = $"Control/TabContainer/2"
@onready var _3: Container = $"Control/TabContainer/3"

const MATERIAL_SELECT = preload("res://ui/structure_menu/material_select_menu/material_select.tscn")

func get_rect() -> Rect2:
	return main_container.get_rect()


func create_material_selections(material_models: Dictionary, currently_selected: MaterialModel) -> void:
	for n_ingredients in material_models.keys():
		for material in material_models[n_ingredients]:
			var material_ui := _create_material_ui(material, n_ingredients)
			if currently_selected:
				material_ui.set_selected(material.material_id == currently_selected.material_id)


func _get_container(n_ingredients: int) -> Container:
	match n_ingredients:
		1:
			return _1.get_child(0).get_child(0) as Container
		2:
			return _2.get_child(0).get_child(0) as Container
		3:
			return _3.get_child(0).get_child(0) as Container
		_:
			return null


func _create_material_ui(model: MaterialModel, n_ingredients: int) -> MaterialSelect:
	var material_ui = MATERIAL_SELECT.instantiate() as MaterialSelect
	_get_container(n_ingredients).add_child(material_ui)
	material_ui.set_model(model)
	material_ui.set_root_ui_node(self)
	return material_ui
