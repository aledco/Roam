class_name PlayerCrafting extends VBoxContainer

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var input_slot_1: CraftingInputMaterialSlot = $HBoxContainer/CraftingInputMaterialSlot1
@onready var input_slot_2: CraftingInputMaterialSlot = $HBoxContainer/CraftingInputMaterialSlot2
@onready var input_slot_3: CraftingInputMaterialSlot = $HBoxContainer/CraftingInputMaterialSlot3
@onready var output_slot: CraftingOutputMaterialSlot = $HBoxContainer/CraftingOutputMaterialSlot
@onready var option_button: OptionButton = $OptionButton

var slots_used_for_output: Array[CraftingInputMaterialSlot] = []
var output_stack: MaterialStack
var selected_item_index := 0
var selected_item_material_id := -1

func _ready():
	input_slot_1.stack_dropped.connect(_on_input_stack_dropped)
	input_slot_2.stack_dropped.connect(_on_input_stack_dropped)
	input_slot_3.stack_dropped.connect(_on_input_stack_dropped)
	input_slot_1.stack_replaced.connect(_on_input_stack_dropped)
	input_slot_2.stack_replaced.connect(_on_input_stack_dropped)
	input_slot_3.stack_replaced.connect(_on_input_stack_dropped)
	input_slot_1.stack_dragged.connect(_on_input_stack_dragged)
	input_slot_2.stack_dragged.connect(_on_input_stack_dragged)
	input_slot_3.stack_dragged.connect(_on_input_stack_dragged)
	output_slot.stack_removed.connect(_on_output_stack_removed)
	
	option_button.item_selected.connect(_on_item_selected)

func _on_input_stack_dropped(stack: MaterialStack):
	if stack == output_stack:
		for slot in slots_used_for_output:
			slot.decrement()
	_create_material_select()

func _on_input_stack_dragged(stack: MaterialStack):
	_create_material_select()

func _on_output_stack_removed(material_id: int):
	for slot in slots_used_for_output:
		slot.decrement()
	_create_material_select()

func _get_valid_input_slots() -> Array[CraftingInputMaterialSlot]:
	var slots: Array[CraftingInputMaterialSlot] = []
	if not input_slot_1.is_empty():
		slots.append(input_slot_1)
	if not input_slot_2.is_empty():
		slots.append(input_slot_2)
	if not input_slot_3.is_empty():
		slots.append(input_slot_3)
	return slots

func _create_material_select():
	option_button.clear()
	output_slot.clear()
	output_stack = null
	slots_used_for_output.clear()
	
	var slots := _get_valid_input_slots()
	if slots.is_empty():
		option_button.hide()
		return
	
	var ingredients: Array[int] = []
	for slot in slots:
		ingredients.append(slot.stack.material_id)
	var models = RawMaterialManager.get_models_from_ingredients(ingredients)
	
	if models.is_empty():
		option_button.hide()
	elif len(models) == 1:
		slots_used_for_output = slots
		_create_output_slot(models.front().material_id)
	else:
		option_button.show()
		slots_used_for_output = slots
		for model in models:
			option_button.add_icon_item(model.image, model.name, model.material_id)
		var selected_item_id = option_button.get_item_id(selected_item_index)
		if selected_item_id == selected_item_material_id:
			option_button.select(selected_item_index)
			_on_item_selected(selected_item_index)
		else:
			option_button.select(0)
			_on_item_selected(0)

func _create_output_slot(material_id: int):
	output_slot.set_slot_material_by_id(material_id)
	output_stack = output_slot.stack

func _on_item_selected(index: int):
	var material_id = option_button.get_item_id(index)
	selected_item_index = index
	selected_item_material_id = material_id
	_create_output_slot(material_id)
