class_name Inventory extends CanvasLayer

@onready var container: Container = $Control/Container

var open_slots: Array[InventorySlot] = []
var slots = {}

func _ready():
	for child in container.get_children():
		var slot := child as InventorySlot
		open_slots.append(slot)


func _get_next_open_slot(slots: Array) -> InventorySlot:
	for slot in slots:
		if not slot.is_full():
			return slot as InventorySlot
	return null

func add_material(material: RawMaterial):
	var slot: InventorySlot = null
	var material_id = material.get_material_id()
	if material_id in slots:
		slot = _get_next_open_slot(slots[material_id])
	if not slot:
		if open_slots.is_empty():
			return
		slot = open_slots.pop_front()
		if material_id in slots:
			slots[material_id].append(slot)
		else:
			slots[material_id] = [slot]

	if slot.is_empty():
		slot.set_slot_material(material)
	else:
		slot.increment()


func remove_material(material_id: int) -> bool:
	if material_id not in slots:
		return false
	
	var slot := _get_next_open_slot(slots[material_id])
	if not slot:
		slot = slots[material_id][0]
	
	slot.decrement()
	if slot.is_empty():
		slots[material_id].remove_at(slots[material_id].find(slot))
		if slots[material_id].is_empty():
			slots.erase(material_id)
		open_slots.append(slot)
	return true


func is_full(material_id: int):
	if not open_slots.is_empty():
		return false
	if material_id in slots:
		return _get_next_open_slot(slots[material_id]) == null
	return true

func get_stored_material_ids() -> Array:
	return slots.keys() as Array[int]
