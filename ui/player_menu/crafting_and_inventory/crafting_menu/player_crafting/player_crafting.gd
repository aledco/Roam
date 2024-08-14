class_name PlayerCrafting extends GridContainer

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var input_slot_1: CraftingInputMaterialSlot = $CraftingInputMaterialSlot1
@onready var input_slot_2: CraftingInputMaterialSlot = $CraftingInputMaterialSlot2
@onready var input_slot_3: CraftingInputMaterialSlot = $CraftingInputMaterialSlot3
@onready var output_slot: CraftingOutputMaterialSlot = $CraftingOutputMaterialSlot
@onready var option_button: OptionButton = $CraftingOutputMaterialSlot/OptionButton

var materials_to_replace = {}
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
	input_slot_3.stack_replaced.connect(_on_input_stack_dragged)
	output_slot.stack_removed.connect(_on_output_stack_removed)
	
	option_button.item_selected.connect(_on_item_selected)

func _get_valid_input_slots() -> Array[CraftingInputMaterialSlot]:
	var slots: Array[CraftingInputMaterialSlot] = []
	if not input_slot_1.is_empty():
		slots.append(input_slot_1)
	if not input_slot_2.is_empty():
		slots.append(input_slot_2)
	if not input_slot_3.is_empty():
		slots.append(input_slot_3)
	return slots

func _reset_slots(slots: Array[CraftingInputMaterialSlot]):
	for slot in slots:
		if slot.stack in materials_to_replace:
			slot.stack.set_amount(slot.stack.amount + materials_to_replace[slot.stack])
			materials_to_replace.erase(slot.stack)

func _on_input_stack_dropped():
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		_reset_slots(valid_slots)
		_create_material_select(valid_slots)
	else:
		_clear_material_select()

func _on_output_stack_removed(material_id: int):
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		for slot in valid_slots:
			if slot.stack in materials_to_replace:
				materials_to_replace.erase(slot.stack)
			
		_create_material_select(valid_slots)
	else:
		_clear_material_select()

func _on_input_stack_dragged(stack: MaterialStack):
	if stack in materials_to_replace:
		stack.set_amount(stack.amount + materials_to_replace[stack])
		materials_to_replace.erase(stack)
	
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		_reset_slots(valid_slots)
		_create_material_select(valid_slots)
	else:
		_clear_material_select()

func _clear_material_select():
	option_button.clear()
	option_button.hide()
	output_slot.clear()

func _create_material_select(slots: Array[CraftingInputMaterialSlot]):
	option_button.clear()
	output_slot.clear()
	
	var ingredients: Array[int] = []
	for slot in slots:
		ingredients.append(slot.stack.material_id)
	var models = RawMaterialManager.get_models_from_ingredients(ingredients)
	
	if models.is_empty():
		option_button.hide()
	else:
		option_button.show()
		for model in models:
			option_button.add_icon_item(model.image, model.name, model.material_id)
		var selected_item_id = option_button.get_item_id(selected_item_index)
		if selected_item_id == selected_item_material_id:
			option_button.select(selected_item_index)
			_on_item_selected(selected_item_index)
		else:
			option_button.select(0)
			_on_item_selected(0)

func _on_item_selected(index: int):
	var material_id = option_button.get_item_id(index)
	selected_item_index = index
	selected_item_material_id = material_id
	
	var valid_slots := _get_valid_input_slots()
	for slot in valid_slots:
		if slot.stack not in materials_to_replace:
			slot.decrement()
			materials_to_replace[slot.stack] = 1
	
	output_slot.set_slot_material_by_id(material_id)
