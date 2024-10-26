class_name PlayerSmelting extends VBoxContainer

const MATERIAL_STACK = preload("res://ui/shared/material_stack/material_stack.tscn")

@onready var fuel_slot: SmeltingInputMaterialSlot = $HBoxContainer/SmeltingInputMaterialSlot1
@onready var smeltable_slot: SmeltingInputMaterialSlot = $HBoxContainer/SmeltingInputMaterialSlot2
@onready var output_slot: SmeltingOutputMaterialSlot = $HBoxContainer/SmeltingOutputMaterialSlot

var smelt_amount := 0

func _ready():
	fuel_slot.stack_dropped.connect(_on_input_stack_dropped)
	smeltable_slot.stack_dropped.connect(_on_input_stack_dropped)
	fuel_slot.stack_replaced.connect(_on_input_stack_dropped)
	smeltable_slot.stack_replaced.connect(_on_input_stack_dropped)
	fuel_slot.stack_dragged.connect(_on_input_stack_dragged)
	smeltable_slot.stack_dragged.connect(_on_input_stack_dragged)
	output_slot.stack_removed.connect(_on_output_stack_removed)
	
	fuel_slot.other_input = smeltable_slot
	smeltable_slot.other_input = fuel_slot

func _are_inputs_valid() -> bool:
	return fuel_slot.stack and smeltable_slot.stack \
		and not fuel_slot.stack.is_empty() and not smeltable_slot.stack.is_empty()

func _on_input_stack_dropped(stack: MaterialStack):
	if _are_inputs_valid():
		_create_output_stack()
	else:
		output_slot.clear()

func _on_output_stack_removed(material_id: int):
	fuel_slot.stack.decrement()
	smeltable_slot.stack.decrement(smelt_amount)
	if _are_inputs_valid():
		_create_output_stack()
	else:
		output_slot.clear()

func _on_input_stack_dragged(stack: MaterialStack):
	output_slot.clear()

func _create_output_stack():
	assert(fuel_slot.stack and smeltable_slot.stack)
	
	var fuel_value := RawMaterialManager.get_material_fuel_value(fuel_slot.stack.material_id)
	var smelt_target_id := RawMaterialManager.get_smelt_target_id(smeltable_slot.stack.material_id)
	
	smelt_amount = fuel_value
	if smeltable_slot.stack.amount < smelt_amount:
		smelt_amount = smeltable_slot.stack.amount
	
	output_slot.set_slot_material_by_id(smelt_target_id, smelt_amount)
