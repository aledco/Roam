class_name PlayerSmelting extends GridContainer

## TODO add glowing animation to output

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var input_slot_1: SmeltingInputMaterialSlot = $SmeltingInputMaterialSlot1
@onready var input_slot_2: SmeltingInputMaterialSlot = $SmeltingInputMaterialSlot2
@onready var output_slot: SmeltingOutputMaterialSlot = $SmeltingOutputMaterialSlot

var materials_to_replace = {}

func _ready():
	input_slot_1.stack_dropped.connect(_on_input_stack_dropped)
	input_slot_2.stack_dropped.connect(_on_input_stack_dropped)
	input_slot_1.stack_replaced.connect(_on_input_stack_dropped)
	input_slot_2.stack_replaced.connect(_on_input_stack_dropped)
	input_slot_1.stack_dragged.connect(_on_input_stack_dragged)
	input_slot_2.stack_dragged.connect(_on_input_stack_dragged)
	output_slot.stack_removed.connect(_on_output_stack_removed)
	
	input_slot_1.other_input = input_slot_2
	input_slot_2.other_input = input_slot_1

func _on_input_stack_dropped():
	if input_slot_1.stack and input_slot_2.stack and not input_slot_1.stack.is_empty() and not input_slot_2.stack.is_empty():
		_create_output_stack()

func _on_output_stack_removed(material_id: int):
	if input_slot_1.stack and input_slot_2.stack and not input_slot_1.stack.is_empty() and not input_slot_2.stack.is_empty():
		_create_output_stack()

func _on_input_stack_dragged(stack: MaterialStack):
	if input_slot_1.stack:
		_replace_materials(input_slot_1.stack, stack)
	elif input_slot_2.stack:
		_replace_materials(input_slot_2.stack, stack)
	output_slot.clear()

func _create_output_stack():
	var fuel_stack: MaterialStack
	var smeltable_stack: MaterialStack
	if RawMaterialManager.is_material_fuel(input_slot_1.stack.material_id):
		fuel_stack = input_slot_1.stack
	elif RawMaterialManager.is_material_fuel(input_slot_2.stack.material_id):
		fuel_stack = input_slot_2.stack
	
	if RawMaterialManager.is_material_smeltable(input_slot_1.stack.material_id):
		smeltable_stack = input_slot_1.stack
	elif RawMaterialManager.is_material_smeltable(input_slot_2.stack.material_id):
		smeltable_stack = input_slot_2.stack
	
	assert(fuel_stack and smeltable_stack)
	
	var fuel_value := RawMaterialManager.get_material_fuel_value(fuel_stack.material_id)
	var smelt_target_id := RawMaterialManager.get_smelt_target_id(smeltable_stack.material_id)
	
	var amount := fuel_value
	if smeltable_stack.amount < amount:
		amount = smeltable_stack.amount
	
	fuel_stack.decrement()
	smeltable_stack.decrement(amount)
	output_slot.set_slot_material_by_id(smelt_target_id, amount)
	
	materials_to_replace[fuel_stack] = 1
	materials_to_replace[smeltable_stack] = amount

func _replace_materials(stack1: MaterialStack, stack2: MaterialStack):
	assert(stack1 in materials_to_replace and stack2 in materials_to_replace)
	
	stack1.set_amount(stack1.amount + materials_to_replace[stack1])
	stack2.set_amount(stack2.amount + materials_to_replace[stack2])
	materials_to_replace.erase(stack1)
	materials_to_replace.erase(stack2)

