extends Control

@onready var button: Button = $Button

func _ready():
	button.pressed.connect(func(): get_tree().change_scene_to_file("res://world/world.tscn"))
