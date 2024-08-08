class_name InventorySlot extends Control

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/RichTextLabel
@onready var sprite_2d: Sprite2D = $Panel/Sprite2D

var material_id: int = -1
var amount: int = 0

func set_slot_material(material: RawMaterial):
	self.material_id = material.get_material_id()
	sprite_2d.texture = material.get_material_image()
	increment()


func increment():
	amount += 1
	text_label.clear()
	text_label.add_text(str(amount))


func decrement(amount_to_remove: int = 1) -> int:
	var left_to_remove := 0
	if amount_to_remove > amount:
		left_to_remove = amount_to_remove - amount
		amount = 0
	else:
		amount -= amount_to_remove
	
	text_label.clear()
	if is_empty():
		material_id = -1
		sprite_2d.texture = null
	else:
		text_label.add_text(str(amount))
	
	return left_to_remove


func is_empty() -> bool:
	return amount == 0


func is_full() -> bool:
	return amount == 99
