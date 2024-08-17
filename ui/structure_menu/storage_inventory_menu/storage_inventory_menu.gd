class_name StorageInventoryMenu extends BaseUI

@onready var tab_container = $Control/TabContainer
@onready var storage_inventory = $Control/TabContainer/Storage/CenterContainer/StorageInventory
@onready var center_container_2 = $Control/TabContainer/Storage/CenterContainer2

func get_rect() -> Rect2:
	return tab_container.get_rect()
	
func _ready():
	super._ready()
	SignalManager.player_input.connect(_on_player_input)

func _on_player_input(input):
	if visible:
		destroy()

func get_storage_inventory() -> StorageInventory:
	return storage_inventory

func _on_visibility_changed():
	super._on_visibility_changed()
	if visible:
		player.player_menu.reparent_inventory(center_container_2)

func destroy():
	player.player_menu.reparent_inventory()
	hide()
