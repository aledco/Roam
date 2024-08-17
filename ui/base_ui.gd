class_name BaseUI extends CanvasLayer

var _player: Player
var player: Player:
	get:
		if not _player:
			_player = get_node("/root/World/Player") as Player
		return _player

func _ready():
	if visible and player:
		player.has_menu_open = true
	visibility_changed.connect(_on_visibility_changed)

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, Vector2.ZERO)

func get_root_control() -> Control:
	return $Control
	
func destroy():
	queue_free()

func _exit_tree():
	if player:
		player.has_menu_open = false

func _on_visibility_changed():
	if player:
		player.has_menu_open = visible

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var ev_local = get_root_control().make_input_local(event)
		if !get_rect().has_point(ev_local.position):
			destroy()
	if event is InputEventKey and event.is_action_pressed("escape"):
		destroy()


static func get_base_ui(node: Node) -> BaseUI:
	var parent_node := node.get_parent()
	while parent_node != null and not parent_node is BaseUI:
		parent_node = parent_node.get_parent()
	if parent_node:
		return parent_node as BaseUI
	return null
