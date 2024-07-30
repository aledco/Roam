class_name TestMaterialSelectUI extends BaseUI

@onready var main_container: Container = $Control/TabContainer
@onready var _1: Container = $"Control/TabContainer/1"
@onready var _2: Container = $"Control/TabContainer/2"
@onready var _3: Container = $"Control/TabContainer/3"

const TEST_MATERIAL_UI = preload("res://ui/test_material_select/test_material_ui.tscn")

func get_rect() -> Rect2:
	return main_container.get_rect()


func create_material_selections(material_models: Dictionary, currently_selected: MaterialModel) -> void:
	for n_ingredients in material_models.keys():
		for material in material_models[n_ingredients]:
			var material_ui := _create_material_ui(material, n_ingredients)
			material_ui.set_selected(material.material_id == currently_selected.material_id)


func _get_container(n_ingredients: int) -> Container:
	match n_ingredients:
		1:
			return _1.get_child(0) as Container
		2:
			return _2.get_child(0) as Container
		3:
			return _3.get_child(0) as Container
		_:
			return null


func _create_material_ui(model: MaterialModel, n_ingredients: int) -> TestMaterialUI:
	var material_ui = TEST_MATERIAL_UI.instantiate() as TestMaterialUI
	_get_container(n_ingredients).add_child(material_ui)
	material_ui.set_model(model)
	material_ui.set_root_ui_node(self)
	return material_ui
