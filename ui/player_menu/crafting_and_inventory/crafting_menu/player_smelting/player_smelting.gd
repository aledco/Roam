class_name PlayerSmelting extends GridContainer

@onready var material_slot_1 = $MaterialSlot1
@onready var material_slot_2 = $MaterialSlot2
@onready var material_slot_3 = $MaterialSlot3

# TODO override MaterialSlot for input/output slots

func _ready():
	material_slot_1.stack_dropped.connect(_on_stack_dropped_slot_1)
	material_slot_2.stack_dropped.connect(_on_stack_dropped_slot_2)
	material_slot_3.stack_dropped.connect(_on_stack_dropped_slot_3)

func _on_stack_dropped_slot_1():
	pass

func _on_stack_dropped_slot_2():
	pass

func _on_stack_dropped_slot_3():
	pass
