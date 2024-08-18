class_name PlayerInventoryMenu extends HBoxContainer

@onready var inventory = $Inventory

func get_inventory() -> Inventory:
	return inventory

func reparent_inventory(new_parent: Node = null):
	if new_parent:
		inventory.reparent(new_parent)
	elif inventory.get_parent() != self:
		inventory.reparent(self)
		move_child(inventory, 0)
