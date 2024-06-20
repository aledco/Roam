class_name CurvedConveyorLeft extends Conveyor

func _ready():
	inputs = [InOutNode.create(self, Vector2i.ZERO, 0)]
	outputs = [InOutNode.create(self, Vector2i.ZERO, PI/2)]
