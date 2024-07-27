extends Node


var current_time: float = 0

const CONVEYOR_FPS := 8
var conveyor_frame := 0


func _process(delta):
	current_time += delta
	conveyor_frame = int(CONVEYOR_FPS / (1 / current_time)) % CONVEYOR_FPS

#func set_animation_frame(animation_sprite: AnimatedSprite2D):
	#var anim = animation_sprite.animation
	#var anim_frame_count = animation_sprite.sprite_frames.get_frame_count(anim)
	#animation_sprite.frame = frame_count % anim_frame_count
	#print("frame: ", frame_count, " anim_frame: ", frame_count % anim_frame_count)
