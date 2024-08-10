class_name StorageInventoryMenu extends BaseUI

@onready var tab_container = $Control/TabContainer
@onready var storage_inventory = $Control/TabContainer/Storage/CenterContainer/StorageInventory
@onready var center_container_2 = $Control/TabContainer/Storage/CenterContainer2
@onready var player = get_node("/root/World/Player") as Player

func get_rect() -> Rect2:
	return tab_container.get_rect()
	
func _ready():
	visibility_changed.connect(_on_visibility_changed)
	SignalManager.player_input.connect(_on_player_input)

func _on_player_input(input):
	if visible:
		destroy()

func get_storage_inventory() -> StorageInventory:
	return storage_inventory

func _on_visibility_changed():
	if visible:
		player.player_menu.reparent_inventory(center_container_2)

func destroy():
	player.player_menu.reparent_inventory()
	hide()
