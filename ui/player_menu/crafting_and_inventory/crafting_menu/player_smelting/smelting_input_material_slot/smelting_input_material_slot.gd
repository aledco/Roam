class_name SmeltingInputMaterialSlot extends MaterialSlot

enum InputType { Fuel, Smeltable }

@export var input_type: InputType
var other_input: SmeltingInputMaterialSlot

func can_drop(stack: MaterialStack):
	if not super.can_drop(stack):
		return false
	
	match input_type:
		InputType.Fuel:
			
			var is_fuel := RawMaterialManager.is_material_fuel(stack.material_id)
			if not is_fuel:
				return false
		InputType.Smeltable:
			var is_smeltable := RawMaterialManager.is_material_smeltable(stack.material_id)
			if not is_smeltable:
				return false
	return true
