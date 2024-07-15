class_name StructureUI extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var texture: TextureRect = $Panel/Button/Texture
@onready var text: RichTextLabel = $Panel/Button/Text

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager

var model: StructureModel
var ui_root: Node

func set_model(model: StructureModel) -> void:
	self.model = model
	
	texture.texture = model.image
	var size := model.image.get_size()
	if size.x > size.y:	
		texture.scale = Vector2(32, size.y / (size.x / 32)) / size
		texture.position = (panel.size / 2) - Vector2(texture.size.x / 1.5, texture.size.y / 4)
	elif size.y > size.x:	
		texture.scale = Vector2(size.x / (size.y / 32), 32) / size
		texture.position = (panel.size / 2) - Vector2(texture.size.x / 4, texture.size.y / 1.5)
	else:
		texture.scale = Vector2(32, 32) / size
	
	text.clear()
	text.text = "[center]%s[/center]" % model.name
	
	button.pressed.connect(_create_structure)


func set_root_ui_node(root: Node):
	ui_root = root


func _create_structure():
	var structure = model.structure.instantiate()
	structure_manager.add_child(structure)
	if model.parent:
		model.parent.queue_free()
		structure.set_position(model.parent.position)
		structure_manager.add_structure(structure)
	else:
		var player := get_node("/root/World/Player") as Node2D
		structure.set_position(player.position)
	
	ui_root.hide()
