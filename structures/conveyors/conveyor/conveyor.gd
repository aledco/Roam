class_name Conveyor extends PathedStructure

static var GRID_SIZE = Vector2i(1, 1)
static var COST := [[IronIngot.MATERIAL_ID, 1]]

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func get_grid_size() -> Vector2i:
	return GRID_SIZE


func _setup_io():
	inputs[0].setup(self, Vector2i.ZERO, 0)
	outputs[0].setup(self, Vector2i.ZERO, 0)


func _ready():
	super._ready()
	assert(inputs.size() == 1)
	assert(outputs.size() == 1)
	_setup_io()
	
	animated_sprite.play("roll")
	animated_sprite.frame = AnimationManager.conveyor_frame
