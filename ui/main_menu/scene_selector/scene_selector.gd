class_name SceneSeletor extends Control

@onready var button: Button = $Button
@onready var texture: TextureRect = $Button/Texture

func set_scene(scene_name: String, scene_path: String, scene_image: Texture2D):
	texture.texture = scene_image
	button.pressed.connect(func(): get_tree().change_scene_to_file(scene_path))
