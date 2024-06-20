class_name ConveyorPlaceholder extends StructurePlaceholder


func _ready():
	animated_sprite_2d.play("blink")


func get_grid_size() -> Vector2i:
	return Conveyor.GRID_SIZE


func _get_structure() -> Resource:
	return preload("res://structures/conveyors/conveyor/conveyor.tscn")
