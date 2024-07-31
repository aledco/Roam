class_name MaterialUI extends Control

@onready var panel = $Panel
@onready var button = $Panel/Button
@onready var texture = $Panel/Button/Texture
@onready var text = $Panel/Button/Text
@onready var overlay: ColorRect = $Panel/Overlay

var model: MaterialModel
var ui_root: Node

func set_model(model: MaterialModel) -> void:
	self.model = model
	
	texture.texture = model.image
	texture.scale = Vector2(16, 16) / model.image.get_size()
	
	text.clear()
	text.text = "[center]%s[/center]" % model.name
	
	button.pressed.connect(_set_material)


func set_root_ui_node(root: Node):
	ui_root = root


func _set_material():
	model.parent.set_current_material(model)
	ui_root.queue_free()

func set_selected(selected: bool):
	overlay.visible = selected

