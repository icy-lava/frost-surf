extends Node

var background_color: Color:
	set(new_color):
		RenderingServer.set_default_clear_color(new_color)
	get:
		return RenderingServer.get_default_clear_color()

var previous_window_mode := DisplayServer.window_get_mode()

func _ready() -> void:
	randomize()

func damp(from: Vector2, to: Vector2, smoothing: float, delta: float) -> Vector2:
	return lerp(from, to, 1.0 - pow(smoothing, delta))

func get_frame_id() -> int:
	return Engine.get_physics_frames()

func get_fixed_fps() -> int:
	return Engine.get_frames_per_second()

func is_window_mode_fullscreen(mode: DisplayServer.WindowMode) -> bool:
	return mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_FULLSCREEN

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		reset_scene()
		return
	
	if event.is_action_pressed("quit"):
		get_tree().quit()
		return
	
	# Toggle fullscreen mode
	if event.is_action_pressed("fullscreen"):
		var current_window_mode := DisplayServer.window_get_mode()
		if is_window_mode_fullscreen(current_window_mode) == is_window_mode_fullscreen(previous_window_mode):
			if is_window_mode_fullscreen(current_window_mode):
				previous_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
			else:
				previous_window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(previous_window_mode)
		previous_window_mode = current_window_mode
		return

func reset_scene() -> void:
	if get_tree().reload_current_scene() != OK:
		assert(false, 'failed to reset current scene')

func play_sound(sound: AudioStreamPlayer, octave_range: float) -> void:
	var clone: AudioStreamPlayer = sound.duplicate()
	clone.get_parent().remove_child(clone)
	get_tree().root.add_child(clone)
	clone.finished.connect(queue_free.bind(clone))
	clone.pitch_scale = pow(2, randf_range(-octave_range, octave_range))
	clone.play()

func get_scale() -> float:
	var screen_size = get_tree().get_root().size
	var set_width = ProjectSettings.get("display/window/size/width")
	var set_height = ProjectSettings.get("display/window/size/height")
	var scale = screen_size / Vector2(set_width, set_height)
	return min(scale.x, scale.y)
