class_name CraftingAndInventoryMenu extends HSplitContainer

@onready var player_inventory_menu: PlayerInventoryMenu = $CenterContainer/PlayerInventoryMenu

func get_inventory() -> Inventory:
	return player_inventory_menu.get_inventory()

func reparent_inventory(new_parent: Node = null):
	player_inventory_menu.reparent_inventory(new_parent)
