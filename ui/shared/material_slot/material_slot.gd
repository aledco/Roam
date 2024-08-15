class_name MaterialSlot extends Control

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

signal stack_dragged(stack: MaterialStack)
signal stack_replaced
signal stack_dropped(stack: MaterialStack)
signal stack_removed(material_id: int)

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var stack: MaterialStack = null

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if is_visible_in_tree():
		activate_area2d()
	else:
		deactivate_area2d()

func deactivate_area2d():
	area_2d.hide()
	collision_shape_2d.disabled = true

func activate_area2d():
	area_2d.show()
	collision_shape_2d.disabled = false

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
	stack.set_amount(99)

func set_slot_material_by_id(material_id: int, amount: int = 1):
	if stack:
		stack.queue_free()
	stack = MATERIAL_STACK.instantiate() as MaterialStack
	add_child(stack)
	stack.setup_alt(self, material_id, RawMaterialManager.get_material_image(material_id), amount)

func clear():
	if stack:
		stack.queue_free()
		stack = null

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
	if stack_dragging:
		return true
	if not stack:
		return false
	return stack.is_full()

func get_amount() -> int:
	if not stack:
		return 0
	return stack.amount

## BEGIN drag and drop code

var detached_stack: MaterialStack
var stack_dragging := false

func begin_stack_drag():
	if stack:
		detached_stack = stack
	stack = null
	stack_dragging = true
	stack_dragged.emit(detached_stack)

func notify_stack_removed():
	if stack:
		stack_removed.emit(stack.material_id)
		stack = null
	elif detached_stack:
		stack_removed.emit(detached_stack.material_id)
		detached_stack = null

func end_stack_drag():
	stack_dragging = false
	if not stack and detached_stack:
		notify_stack_removed()

## Add the stack to the slot and update inventory.
func add_stack(stack_to_add: MaterialStack) -> bool:
	if not stack:
		stack = stack_to_add
		stack_dropped.emit(stack)
	elif stack.material_id == stack_to_add.material_id:
		if stack.amount + stack_to_add.amount <= MaterialStack.MAX_STACK:
			stack.set_amount(stack.amount + stack_to_add.amount)
			stack_to_add.queue_free()
		else:
			var amount_left = stack.amount + stack_to_add.amount - MaterialStack.MAX_STACK
			stack.set_amount(MaterialStack.MAX_STACK)
			stack_to_add.set_amount(amount_left)
			return true
	else:
		stack.force_start_drag()
		stack = stack_to_add
		stack_dropped.emit(stack)
	return false

func replace_stack():
	stack_dragging = false
	if not detached_stack:
		return
	
	if stack:
		stack.set_amount(stack.amount + detached_stack.amount)
		detached_stack.queue_free()
	else:
		stack = detached_stack
	stack_replaced.emit()
	end_stack_drag()

static var count = 0
## Determines if the mouse is hovering above the slot.
func is_mouse_over_slot() -> bool:
	var rect = get_global_rect()
	var mouse_pos = get_global_mouse_position()
	print("COUNT: ", count)
	count += 1
	print("SIZE: ", size)
	print("RECT: ", Rect2(Vector2.ZERO, size))
	print("MOUSE_POS: ", get_local_mouse_position())
	print("HAS_POINT: ", Rect2(Vector2.ZERO, size).has_point(get_local_mouse_position()))
	print()
	return Rect2(Vector2.ZERO, size).has_point(get_local_mouse_position())

## The stack can be dropped if the slot is empty or the stack is the same material.
func can_drop(stack_to_drop: MaterialStack) -> bool:
	print("IS_EMPTY: ", is_empty())
	return is_empty() \
		or (stack.material_id == stack_to_drop.material_id and not stack.is_full()) \
		or stack.material_id != stack_to_drop.material_id

## END drag and drop code
