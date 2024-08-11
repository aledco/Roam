class_name SmeltingInputMaterialSlot extends MaterialSlot

var other_input: SmeltingInputMaterialSlot
var output: SmeltingOutputMaterialSlot

func can_drop(stack: MaterialStack):
	if not super.can_drop(stack):
		return false
	
	var is_fuel := RawMaterialManager.is_material_fuel(stack.material_id)
	var is_smeltable := RawMaterialManager.is_material_smeltable(stack.material_id)
	if not is_fuel and not is_smeltable:
		return false
	
	if other_input.stack:
		var other_is_fuel := RawMaterialManager.is_material_fuel(other_input.stack.material_id)
		var other_is_smeltable := RawMaterialManager.is_material_smeltable(other_input.stack.material_id)
		if is_fuel and other_is_fuel:
			return false
		if is_smeltable and other_is_smeltable:
			return false
	return true
