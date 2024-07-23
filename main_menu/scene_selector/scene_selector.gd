class_name SceneSeletor extends Control

@onready var panel: Panel = $Panel
@onready var button: Button = $Panel/Button
@onready var texture: TextureRect = $Panel/Button/Texture
@onready var text: RichTextLabel = $Panel/Button/Text


func set_scene(scene_name: String, scene_path: String, scene_image: Texture2D):
	text.text = "[center]%s[/center]" % scene_name
	
	texture.texture = scene_image
	var size := scene_image.get_size()
	if size.x > size.y:
		texture.scale = Vector2(32, panel.size.y / (size.x / 32)) / size
		texture.position = (panel.size / 2) - Vector2(texture.size.x / 1.5, texture.size.y / 4)
	elif size.y > size.x:
		texture.scale = Vector2(panel.size.x / (size.y / 32), 32) / size
		texture.position = (panel.size / 2) - Vector2(texture.size.x / 4, texture.size.y / 1.5)
	else:
		texture.scale = Vector2(32, 32) / size
	
	button.pressed.connect(func(): get_tree().change_scene_to_file(scene_path))
