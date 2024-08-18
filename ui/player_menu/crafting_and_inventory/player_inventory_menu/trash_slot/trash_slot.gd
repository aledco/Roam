class_name TrashSlot extends MaterialSlot

const TRASHCAN_CLOSED = preload("res://ui/player_menu/crafting_and_inventory/player_inventory_menu/trash_slot/trashcan_closed.png")
const TRASHCAN_OPEN = preload("res://ui/player_menu/crafting_and_inventory/player_inventory_menu/trash_slot/trashcan_open.png")

enum TrashcanStatus { Open, Closed }

@onready var trashcan: TextureRect = $Trashcan
@onready var player := get_node("/root/World/Player") as Player

var trashcan_status := TrashcanStatus.Closed


func _ready():
	stack_dropped.connect(_on_stack_dropped)
	
func _on_stack_dropped(_stack: MaterialStack):
	stack.queue_free()
	stack = null

func can_drop(stack: MaterialStack):
	return true

func _process(delta):
	if player.is_dragging_stack and is_mouse_over_slot():
		if trashcan_status == TrashcanStatus.Closed:
			trashcan_status = TrashcanStatus.Open
			trashcan.texture = TRASHCAN_OPEN
	elif trashcan_status == TrashcanStatus.Open:
		trashcan_status = TrashcanStatus.Closed
		trashcan.texture = TRASHCAN_CLOSED
