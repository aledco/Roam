class_name Conveyor extends SinglePathStructure

static var GRID_SIZE = Vector2i(1, 1)

func get_grid_size() -> Vector2i:
	return GRID_SIZE


func _ready():
	inputs = [InOutNode.create(self, Vector2i.ZERO, 0)]
	outputs = [InOutNode.create(self, Vector2i.ZERO, 0)]
