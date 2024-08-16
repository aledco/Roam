class_name MaterialStack extends Control

static var MAX_STACK = 99
const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var texture_rect: TextureRect = $TextureRect
@onready var text_label: RichTextLabel = $TextLabel
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var slot: MaterialSlot
var material_id: int = -1
var amount: int = 0

func _ready():
	texture_rect.texture = null
	text_label.clear()
	visibility_changed.connect(func(): _on_visibility_changed())

func deactivate_area2d():
	area_2d.hide()
	collision_shape_2d.disabled = true

func activate_area2d():
	area_2d.show()
	collision_shape_2d.disabled = false

func setup(slot: MaterialSlot, material: RawMaterial):
	self.slot = slot
	material_id = material.get_material_id()
	texture_rect.texture = material.get_material_image()
	increment()

func setup_alt(slot: MaterialSlot, material_id: int, material_image: Texture2D, amount: int = 1):
	assert(amount <= MAX_STACK)
	self.slot = slot
	self.material_id = material_id
	texture_rect.texture = material_image
	set_amount(amount)

func set_amount(new_amount: int):
	if new_amount > MAX_STACK:
		return
	amount = new_amount
	text_label.clear()
	text_label.add_text(str(amount))

func increment():
	if amount + 1 > MAX_STACK:
		return
	set_amount(amount + 1)

func decrement(amount_to_remove: int = 1) -> int:
	var left_to_remove := 0
	if amount_to_remove > amount:
		left_to_remove = amount_to_remove - amount
		amount = 0
	else:
		amount -= amount_to_remove
	
	if is_empty():
		slot.notify_stack_removed()
		slot.stack = null
		queue_free()
	else:
		text_label.clear()
		text_label.add_text(str(amount))
	
	return left_to_remove


func is_empty() -> bool:
	return amount == 0


func is_full() -> bool:
	return amount == MAX_STACK

## BEGIN drag and drop code

var is_dragging := false
var grabbed_offset: Vector2

## Splits the stack in two.
func _split_stack(amount_to_split: int = -1, slot_parent: MaterialSlot = null) -> MaterialStack:
	var split_amount1: int
	if amount_to_split == -1:
		split_amount1 = amount / 2
	else:
		split_amount1 = amount_to_split
	var split_amount2 := amount - split_amount1
	
	if not slot_parent:
		slot_parent = slot
	
	var stack = MATERIAL_STACK.instantiate() as MaterialStack
	slot_parent.add_child(stack)
	stack.slot = slot_parent
	stack.material_id = material_id
	stack.texture_rect.texture = texture_rect.texture.duplicate()
	
	set_amount(split_amount2)
	stack.set_amount(split_amount1)
	slot_parent.add_stack(stack)
	return stack

## Forces a drag.
func force_start_drag():
	_start_drag(MOUSE_BUTTON_LEFT)

## Starts dragging the stack.
func _start_drag(button_index: int):
	var base_ui := BaseUI.get_base_ui(self)
	if not base_ui:
		return
	
	reparent(base_ui)
	
	is_dragging = true
	grabbed_offset = global_position - get_global_mouse_position()
	slot.begin_stack_drag()
	activate_area2d()
	if button_index == MOUSE_BUTTON_RIGHT and amount > 1:
		_split_stack()

## Ends dragging the stack.
func _end_drag(button_index: int):
	var target := _get_drop_target()
	if target and target.can_drop(self):
		if button_index == MOUSE_BUTTON_RIGHT and amount > 1:
			if target.stack:
				target.stack.increment()
				decrement()
			else:
				_split_stack(1, target)
			return
		else:
			if slot == target:
				slot.replace_stack()
			else:
				var stack_still_exists := target.add_stack(self)
				if stack_still_exists:
					return
				slot.end_stack_drag()
				slot = target
	else:
		slot.replace_stack()

	is_dragging = false
	deactivate_area2d()
	reparent(slot)
	position = Vector2.ZERO

## When stack is hidden, if it is being dragged, set back to the original slot.
func _on_visibility_changed():
	if is_visible_in_tree():
		activate_area2d()
	else:
		deactivate_area2d()
		if is_dragging:
			is_dragging = false
			slot.replace_stack()
			reparent.call_deferred(slot)
			set_position.call_deferred(Vector2.ZERO)


## Gets the target slot when dropping the stack.
func _get_drop_target() -> MaterialSlot:
	var slots_areas = area_2d.get_overlapping_areas()
	for slot_area in slots_areas:
		var slot = slot_area.get_parent() as MaterialSlot
		if slot.is_mouse_over_slot():
			return slot
	return null

## Check for dragging event.
func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
			return
		if is_dragging:
			_end_drag(mouse_event.button_index)
			return
		
		var ev_local := make_input_local(event)
		var rect = get_global_rect()
		if rect.has_point(ev_local.global_position):
			_start_drag(mouse_event.button_index)


## Update the stacks position when dragging.
func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + grabbed_offset

## END drag and drop code
