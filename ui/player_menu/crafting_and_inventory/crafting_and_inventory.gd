class_name CraftingAndInventoryContainer extends HSplitContainer

@onready var inventory: Inventory = $CenterContainer/Inventory

func get_inventory() -> Inventory:
	return inventory
