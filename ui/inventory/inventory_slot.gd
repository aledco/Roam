class_name InventorySlot extends Control

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/RichTextLabel
@onready var sprite_2d: Sprite2D = $Panel/Sprite2D

var material_id: int = -1
var amount: int = 0

func fill_slot(material: RawMaterial):
	self.material_id = material.get_material_id()
	sprite_2d.texture = material.get_material_image()
	increment()


func increment():
	amount += 1
	text_label.clear()
	text_label.add_text(str(amount))


func is_empty() -> bool:
	return amount == 0


func is_full() -> bool:
	return amount == 99
