class_name PlayerMenu extends BaseUI

@onready var tab_container: TabContainer = $Control/TabContainer
@onready var craft_and_inventory: CraftingAndInventoryMenu = $Control/TabContainer/Inventory

func get_rect() -> Rect2:
	return tab_container.get_rect()

func destroy():
	hide()

func get_inventory() -> Inventory:
	return craft_and_inventory.get_inventory()

func reparent_inventory(new_parent: Node = null):
	craft_and_inventory.reparent_inventory(new_parent)
