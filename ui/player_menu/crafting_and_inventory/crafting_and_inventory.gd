class_name CraftingAndInventoryContainer extends HSplitContainer

@onready var center_container: CenterContainer = $CenterContainer
@onready var inventory: Inventory = $CenterContainer/Inventory

func get_inventory() -> Inventory:
	return inventory

func reparent_inventory(new_parent: Node = null):
	if new_parent:
		inventory.reparent(new_parent)
	elif inventory.get_parent() != center_container:
		inventory.reparent(center_container)
