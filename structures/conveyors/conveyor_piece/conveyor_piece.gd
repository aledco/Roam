class_name ConveyorPiece extends AnimatedSprite2D

func _ready():
	play("roll")
	frame = AnimationManager.conveyor_frame
