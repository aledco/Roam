class_name Tunnel extends StaticBody2D

@onready var structure: Structure = get_parent() as Structure

func _input_event(viewport, event, shape_idx):
	structure._input_event(viewport, event, shape_idx)
