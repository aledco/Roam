class_name Smoke extends AnimatedSprite2D

var is_active := false

var _is_starting := false
var _is_ending := false

func start():
	is_active = true
	_is_starting = true
	if _is_ending:
		_is_ending = false
		animation_finished.disconnect(_on_smoke_end_finished)
		var cframe = frame
		var cprogress = frame_progress
		play("smoke_start")
		set_frame_and_progress(cframe, cprogress)
	else:
		play("smoke_start")
	animation_finished.disconnect(_on_smoke_start_finished)
	animation_finished.connect(_on_smoke_start_finished)

func _on_smoke_start_finished():
	_is_starting = false
	play("smoke")
	animation_finished.disconnect(_on_smoke_start_finished)


func dissapate():
	_is_ending = true
	if _is_starting:
		_is_starting = false
		animation_finished.disconnect(_on_smoke_start_finished)
		var cframe = frame
		var cprogress = frame_progress
		play_backwards("smoke_start")
		set_frame_and_progress(cframe, cprogress)
	else:
		play_backwards("smoke_start")
	animation_finished.disconnect(_on_smoke_end_finished)
	animation_finished.connect(_on_smoke_end_finished)

func _on_smoke_end_finished():
	is_active = false
	_is_ending = false
	play("default")
	animation_finished.disconnect(_on_smoke_end_finished)
