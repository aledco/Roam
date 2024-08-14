class_name Inventory extends GridContainer

var open_slots: Array[MaterialSlot] = []
var slots = {}

func _ready():
	for child in get_children():
		var slot := child as MaterialSlot
		slot.stack_removed.connect(_on_stack_removed.bind(slot))
		slot.stack_dropped.connect(_on_stack_dropped.bind(slot))
		open_slots.append(slot)
	_sort_open_slots()


func _on_stack_dropped(slot: MaterialSlot):
	assert(slot.stack != null)
	
	if slot in open_slots:
		var material_id = slot.stack.material_id
		Helpers.remove(open_slots, slot)
	
		if material_id in slots:
			slots[material_id].append(slot)
		else:
			slots[material_id] = [slot]

func _on_stack_removed(material_id: int, slot: MaterialSlot):
	if material_id in slots and slot in slots[material_id]:
		Helpers.remove(slots[material_id], slot)
		_free_slot(slot)


func _get_next_open_slot(slots: Array) -> MaterialSlot:
	for slot in slots:
		if not slot.is_full():
			return slot as MaterialSlot
	return null


func add_material(material: RawMaterial):
	var slot: MaterialSlot = null
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


func remove_material(material_id: int, amount: int = 1) -> bool:
	if not contains_material(material_id, amount):
		return false
	
	while amount > 0:
		var slot := _get_next_open_slot(slots[material_id])
		if not slot:
			slot = slots[material_id][0]

		amount = slot.decrement(amount)
	return true


func is_full(material_id: int):
	if not open_slots.is_empty():
		return false
	if material_id in slots:
		return _get_next_open_slot(slots[material_id]) == null
	return true


func get_stored_material_ids() -> Array:
	return slots.keys() as Array[int]


func contains_material(material_id: int, amount: int = 1) -> bool:
	if material_id not in slots:
		return false
	
	var found_amount := 0
	for slot in slots[material_id]:
		found_amount += slot.get_amount()
		if found_amount >= amount:
			return true
	
	return false

func _free_slot(slot: MaterialSlot):
	open_slots.append(slot)
	_sort_open_slots()

func _sort_open_slots():
	open_slots.sort_custom(func(a, b): return a.get_index() < b.get_index())
