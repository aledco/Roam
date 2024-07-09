class_name Inventory extends CanvasLayer

@onready var container: GridContainer = $Control/Container

const INVENTORY_SLOT = preload("res://ui/inventory/inventory_slot.tscn")

var slots = {}

func add_material(material: RawMaterial):
	var slot := _get_slot(material.get_material_id())
	if slot == null:
		return
	
	if slot.is_empty():
		slot.fill_slot(material)
	else:
		slot.increment()


func _get_slot(material_id: int) -> InventorySlot:
	for child in container.get_children():
		var slot := child as InventorySlot
		if material_id == slot.material_id and not slot.is_full():
			return slot
			
	for child in container.get_children():
		var slot := child as InventorySlot
		if slot.is_empty():
			return slot
		
	return null	
 

func is_full(material_id: int):
	return _get_slot(material_id) == null
