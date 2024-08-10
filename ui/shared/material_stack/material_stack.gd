class_name MaterialStack extends Control

static var MAX_STACK = 99
const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var texture_rect: TextureRect = $TextureRect
@onready var text_label: RichTextLabel = $TextLabel
@onready var area_2d: Area2D = $Area2D

var slot: MaterialSlot
var material_id: int = -1
var amount: int = 0

func _ready():
	texture_rect.texture = null
	text_label.clear()
	visibility_changed.connect(func(): _on_visibility_changed())

func setup(slot: MaterialSlot, material: RawMaterial):
	self.slot = slot
	material_id = material.get_material_id()
	texture_rect.texture = material.get_material_image()
	increment()

func set_amount(new_amount: int):
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
	
	text_label.clear()
	if is_empty():
		material_id = -1
		texture_rect.texture = null
	else:
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
	slot_parent.add_stack(stack)
	stack.slot = slot_parent
	stack.material_id = material_id
	stack.texture_rect.texture = texture_rect.texture.duplicate()
	stack.set_amount(split_amount1)
	set_amount(split_amount2)
	return stack

## Starts dragging the stack.
func _start_drag(button_index: int):
	var base_ui := BaseUI.get_base_ui(self)
	if not base_ui:
		return
	
	reparent(base_ui)
	
	is_dragging = true
	grabbed_offset = global_position - get_global_mouse_position()
	slot.remove_stack()
	area_2d.show()
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
			var stack_still_exists := target.add_stack(self)
			if stack_still_exists:
				return
			slot = target
	else:
		slot.add_stack(self)

	is_dragging = false
	area_2d.hide()
	reparent(slot)
	position = Vector2.ZERO

## When stack is hidden, if it is being dragged, set back to the original slot.
func _on_visibility_changed():
	if not is_visible_in_tree() and is_dragging:
		is_dragging = false
		area_2d.hide()
		slot.add_stack(self)
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
