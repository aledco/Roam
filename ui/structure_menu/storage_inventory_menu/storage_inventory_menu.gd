class_name StorageInventoryMenu extends BaseUI

@onready var panel_container: Container = $Control/PanelContainer
@onready var storage_inventory: Inventory = $Control/PanelContainer/Storage/CenterContainer/VBoxContainer/StorageInventory
@onready var inventory_container: Container = $Control/PanelContainer/Storage/CenterContainer2/VBoxContainer

func get_rect() -> Rect2:
	return panel_container.get_rect()
	
func _ready():
	super._ready()
	SignalManager.player_input.connect(_on_player_input)

func _on_player_input(input):
	if visible:
		destroy()

func get_storage_inventory() -> Inventory:
	return storage_inventory

func _on_visibility_changed():
	super._on_visibility_changed()
	if visible:
		player.player_menu.reparent_inventory(inventory_container)

func destroy():
	player.player_menu.reparent_inventory()
	hide()
