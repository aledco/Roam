class_name StructureBuildMenu extends BaseUI

@onready var container: Container = $Control/PanelContainer/ScrollContainer/MarginContainer/Container
@onready var button: Button = $Control/Button
@onready var texture_rect: TextureRect = $Control/Button/TextureRect

# TODO button is broken because not in rect, move button function to special ui

const STRUCTURE_SELECT = preload("res://ui/shared/structure_select/structure_select.tscn")
const DRILL_PLAYER_DISPLAY = preload("res://player/display/drill_player_display.png")
const SAW_PLAYER_DISPLAY = preload("res://player/display/saw_player_display.png")

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, get_root_control().size)


func create_structure_selections(structures: Array[StructureModel], can_saw: bool, can_drill: bool) -> void:
	for structure in structures:
		_create_structure_ui(structure)
	if can_saw or can_drill:
		button.show()
		if can_saw:
			button.pressed.connect(_player_saw)
			texture_rect.texture = SAW_PLAYER_DISPLAY
		elif can_drill:
			button.pressed.connect(_player_drill)
			texture_rect.texture = DRILL_PLAYER_DISPLAY
	else:
		button.hide()


func _player_saw():
	var player := get_node("/root/World/Player") as Player
	player.saw(get_parent() as MinableStructure)
	queue_free()


func _player_drill():
	var player := get_node("/root/World/Player") as Player
	player.drill(get_parent() as MinableStructure)
	queue_free()


func _create_structure_ui(model: StructureModel):
	var structure_ui = STRUCTURE_SELECT.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
