class_name OutputSelect extends StaticBody2D

const OUTPUT_SELECT_UI = preload("res://ui/structure_menu/output_select/output_select_ui.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var output_select_ui: OutputSelectUI = $OutputSelectUI

@onready var player = get_node("/root/World/Player")

var storage: Storage
var current_material: MaterialModel

func set_current_material(model: MaterialModel):
	current_material = model

func setup(storage: Storage):
	self.storage = storage

func update():
	output_select_ui.update_material_selections(_get_material_models(), current_material)

func _mouse_enter():
	if not output_select_ui.visible:
		animated_sprite_2d.play("hover")

func _mouse_exit():
	animated_sprite_2d.play("default")

func _input_event(viewport, event, shape_idx):
	if output_select_ui.visible or player.is_busy():
		return
	
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			animated_sprite_2d.play("default")
			animated_sprite_2d.play("press")
			output_select_ui.show()
			update()

func _get_material_models() -> Array[MaterialModel]:
	var models: Array[MaterialModel] = []
	var material_ids = storage.get_stored_material_ids()
	for material_id in material_ids:
		var model = RawMaterialManager.get_model(material_id, self)
		models.append(model)
	return models
