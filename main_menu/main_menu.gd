extends Control

@onready var play_button: Button = $PlayButton
@onready var test_button: Button = $TestButton
@onready var tests_menu: CanvasLayer = $TestsMenu

func _ready():
	play_button.pressed.connect(func(): get_tree().change_scene_to_file("res://world/world.tscn"))
	test_button.pressed.connect(tests_menu.show)
