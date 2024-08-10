class_name CraftingAndInventoryMenu extends HSplitContainer

@onready var center_container2: CenterContainer = $CenterContainer2
@onready var inventory: Inventory = $CenterContainer2/Inventory

func get_inventory() -> Inventory:
	return inventory

func reparent_inventory(new_parent: Node = null):
	if new_parent:
		inventory.reparent(new_parent)
	elif inventory.get_parent() != center_container2:
		inventory.reparent(center_container2)
