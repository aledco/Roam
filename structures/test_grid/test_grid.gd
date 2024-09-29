class_name TestGrid extends Structure

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	super._ready()
	var shape := RectangleShape2D.new()
	shape.size = get_grid_size() * 32
	collision_shape_2d.shape = shape
