class_name StorageUI extends Inventory

@onready var control: Control = $Control

func get_size() -> Vector2:
	return container.size


func destroy():
	hide()


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var ev_local = control.make_input_local(event)
		if !Rect2(Vector2.ZERO, get_size()).has_point(ev_local.position):
			destroy()
	if event is InputEventKey and event.is_action_pressed("escape"):
		destroy()

func get_stored_material_ids() -> Array[int]:
	var ids: Array[int] = []
	for child in container.get_children():
		var slot := child as InventorySlot
		if slot.material_id > 0 and slot.material_id not in ids:
			ids.append(slot.material_id)
	return ids
