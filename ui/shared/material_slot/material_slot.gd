class_name MaterialSlot extends Panel

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

var stack: MaterialStack = null
var inventory: Inventory = null

func setup(inventory: Inventory):
	self.inventory = inventory

func get_material_id() -> int:
	if not stack:
		return -1
	return stack.material_id

func get_material_amount() -> int:
	if not stack:
		return 0
	return stack.amount

func set_slot_material(material: RawMaterial):
	if stack:
		stack.queue_free()
	stack = MATERIAL_STACK.instantiate() as MaterialStack
	add_child(stack)
	stack.setup(self, material)

func increment():
	if not stack:
		return
	stack.increment()

func decrement(amount_to_remove: int = 1) -> int:
	if not stack:
		return 0
	return stack.decrement()


func is_empty() -> bool:
	if not stack:
		return true
	return stack.is_empty()


func is_full() -> bool:
	if not stack:
		return false
	return stack.is_full()

## BEGIN drag and drop code

## Remove the stack from the slot and update the inventory.
func remove_stack():
	if not stack:
		return
	
	inventory.stack_moved_from(self, stack.material_id)
	stack = null


## Add the stack to the slot and update inventory.
func add_stack(stack_to_add: MaterialStack):
	if not stack:
		stack = stack_to_add
		inventory.stack_moved_to(self, stack.material_id)
	else:
		if stack.material_id == stack_to_add.material_id:
			if stack.amount + stack_to_add.amount <= MaterialStack.MAX_STACK:
				stack.set_amount(stack.amount + stack_to_add.amount)
				stack_to_add.queue_free()
			else:
				var amount_left = stack.amount + stack_to_add.amount - MaterialStack.MAX_STACK
				stack.set_amount(MaterialStack.MAX_STACK)
				stack_to_add.set_amount(amount_left)


## Determines if the mouse is hovering above the slot.
func is_mouse_over_slot() -> bool:
	var rect = get_global_rect()
	var mouse_pos = get_global_mouse_position()
	return rect.has_point(mouse_pos)

## The stack can be dropped if the slot is empty or the stack is the same material.
func can_drop(stack_to_drop: MaterialStack) -> bool:
	return is_empty() or (stack.material_id == stack_to_drop.material_id and not stack.is_full())

## END drag and drop code
