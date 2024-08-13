class_name PlayerCrafting extends GridContainer

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var input_slot_1: CraftingInputMaterialSlot = $CraftingInputMaterialSlot1
@onready var input_slot_2: CraftingInputMaterialSlot = $CraftingInputMaterialSlot2
@onready var input_slot_3: CraftingInputMaterialSlot = $CraftingInputMaterialSlot3
@onready var output_slot: CraftingOutputMaterialSlot = $CraftingOutputMaterialSlot
@onready var option_button: OptionButton = $CraftingOutputMaterialSlot/OptionButton

var materials_to_replace = {}

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
	
	_create_material_select([])

func _get_valid_input_slots() -> Array[CraftingInputMaterialSlot]:
	var slots: Array[CraftingInputMaterialSlot] = []
	if not input_slot_1.is_empty():
		slots.append(input_slot_1)
	if not input_slot_2.is_empty():
		slots.append(input_slot_2)
	if not input_slot_3.is_empty():
		slots.append(input_slot_3)
	return slots

func _on_input_stack_dropped():
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		_create_material_select(valid_slots)

func _on_output_stack_removed(material_id: int):
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		_create_material_select(valid_slots)

func _on_input_stack_dragged(stack: MaterialStack):
	if stack in materials_to_replace:
		stack.set_amount(stack.amount + materials_to_replace[stack])
		materials_to_replace.erase(stack)
	
	var valid_slots := _get_valid_input_slots()
	if not valid_slots.is_empty():
		_create_material_select(valid_slots) # TODO replace materials if no valid materials to craft

func _create_material_select(slots: Array[CraftingInputMaterialSlot]):
	option_button.clear()
	
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

#func _create_output_stack():
	#var fuel_stack: MaterialStack
	#var smeltable_stack: MaterialStack
	#if RawMaterialManager.is_material_fuel(input_slot_1.stack.material_id):
		#fuel_stack = input_slot_1.stack
	#elif RawMaterialManager.is_material_fuel(input_slot_2.stack.material_id):
		#fuel_stack = input_slot_2.stack
	#
	#if RawMaterialManager.is_material_smeltable(input_slot_1.stack.material_id):
		#smeltable_stack = input_slot_1.stack
	#elif RawMaterialManager.is_material_smeltable(input_slot_2.stack.material_id):
		#smeltable_stack = input_slot_2.stack
	#
	#assert(fuel_stack and smeltable_stack)
	#
	#var fuel_value := RawMaterialManager.get_material_fuel_value(fuel_stack.material_id)
	#var smelt_target_id := RawMaterialManager.get_smelt_target_id(smeltable_stack.material_id)
	#
	#var amount := fuel_value
	#if smeltable_stack.amount < amount:
		#amount = smeltable_stack.amount
	#
	#fuel_stack.decrement()
	#smeltable_stack.decrement(amount)
	#output_slot.set_slot_material_by_id(smelt_target_id, amount)
	#
	#materials_to_replace[fuel_stack] = 1
	#materials_to_replace[smeltable_stack] = amount
