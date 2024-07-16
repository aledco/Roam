class_name BuildUI extends BaseUI

@onready var main_container: ScrollContainer = $Control/ScrollContainer
@onready var container: Container = $Control/ScrollContainer/Container
@onready var button: Button = $Control/Button
@onready var texture_rect: TextureRect = $Control/Button/TextureRect

const STRUCTURE_UI = preload("res://ui/build/structure_ui.tscn")
const DRILL_PLAYER_DISPLAY = preload("res://player/display/drill_player_display.png")
const SAW_PLAYER_DISPLAY = preload("res://player/display/saw_player_display.png")

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, control.size)


func create_structure_selections(structures: Array[StructureModel], can_saw: bool, can_drill: bool) -> void:
	for structure in structures:
		_create_structure_ui(structure)
	if len(structures) == 1:
		main_container.set_size(main_container.get_size() * Vector2(1, 0.5) - Vector2(10, 0))
		main_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
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
	var structure_ui = STRUCTURE_UI.instantiate()
	container.add_child(structure_ui)
	structure_ui.set_model(model)
	structure_ui.set_root_ui_node(self)
