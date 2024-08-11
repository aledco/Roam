class_name SmeltingOutputMaterialSlot extends MaterialSlot

var input1: SmeltingInputMaterialSlot
var input2: SmeltingInputMaterialSlot

func can_drop(stack: MaterialStack):
	return false
