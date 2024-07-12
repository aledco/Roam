class_name BaseUI extends CanvasLayer

@onready var control: Control = $Control

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, Vector2.ZERO)


func destroy():
	queue_free()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var ev_local = control.make_input_local(event)
		if !get_rect().has_point(ev_local.position):
			destroy()
	if event is InputEventKey and event.is_action_pressed("escape"):
		destroy()
