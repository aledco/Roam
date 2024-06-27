class_name StructureUI extends Control

@onready var panel = $Panel
@onready var button = $Panel/Button
@onready var texture = $Panel/Button/Texture
@onready var text = $Panel/Button/Text

@onready var structure_manager := get_node("/root/World/StructureManager") as StructureManager

var model: StructureModel
var ui_root: Node

func get_ui_size() -> Vector2:
	return panel.size


func set_model(model: StructureModel) -> void:
	self.model = model
	
	texture.texture = model.image
	texture.scale = Vector2(32, 32) / model.image.get_size()
	
	text.clear()
	text.text = "[center]%s $%s[/center]" % [model.name, str(model.cost)]
	
	button.pressed.connect(_create_structure)


func set_root_ui_node(root: Node):
	ui_root = root


func _create_structure():
	var structure = model.structure.instantiate()
	structure_manager.add_child(structure)
	if model.parent:
		model.parent.queue_free()
		structure.set_position(model.parent.position)
	else:
		var player := get_node("/root/World/Player") as Node2D
		structure.set_position(player.position)
	
	if not model.is_placeholder:
		structure_manager.add_structure(structure)
	
	ui_root.queue_free()
