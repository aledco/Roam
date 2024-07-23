class_name TestsMenu extends BaseUI

const SCENE_SELECTOR = preload("res://main_menu/scene_selector/scene_selector.tscn")

@onready var container: Container = $Control/Container

func get_rect() -> Rect2:
	return container.get_rect()

func destroy():
	hide()

func _ready():
	const base_path := "res://tests"
	var dir := DirAccess.open(base_path)
	if dir:
		dir.list_dir_begin()
		var item := dir.get_next()
		while item != "":
			if dir.current_is_dir():
				var path := base_path + "/" + item + "/" + item
				var scene_path = path + ".tscn"
				var image_path = path + ".png"
				
				var scene_name_parts := item.split("_")
				for i in range(len(scene_name_parts)):
					scene_name_parts[i] = scene_name_parts[i].capitalize()
				var scene_name := " ".join(scene_name_parts)
				
				var scene_selector := SCENE_SELECTOR.instantiate() as SceneSeletor
				container.add_child(scene_selector)
				scene_selector.set_scene(scene_name, scene_path, load(image_path))
			item = dir.get_next()
