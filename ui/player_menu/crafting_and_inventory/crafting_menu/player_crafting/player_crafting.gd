class_name PlayerCrafting extends GridContainer

@onready var material_slot_1: MaterialSlot = $MaterialSlot
@onready var material_slot_2: MaterialSlot = $MaterialSlot2
@onready var material_slot_3: MaterialSlot = $MaterialSlot3
@onready var inputs: Array[MaterialSlot] = [material_slot_1, material_slot_2, material_slot_3]
@onready var output_material_slot: MaterialSlot = $MaterialSlot4
