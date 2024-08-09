class_name MaterialSlot extends Panel

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

var stack: MaterialStack = null


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
	add_child(stack) # TODO use center container
	stack.set_stack_material(material)

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
