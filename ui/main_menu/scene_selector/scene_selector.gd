class_name SceneSeletor extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var texture: TextureRect = $Panel/Button/Texture
@onready var text: RichTextLabel = $Panel/Button/Text


func set_scene(scene_name: String, scene_path: String, scene_image: Texture2D):
	text.text = "[center]%s[/center]" % scene_name
	texture.texture = scene_image
	button.pressed.connect(func(): get_tree().change_scene_to_file(scene_path))
