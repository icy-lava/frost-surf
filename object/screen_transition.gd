extends CanvasLayer
class_name ScreenTransition

func _ready():
	$AnimationPlayer.play("fade_to_normal")

func transition(target: PackedScene):
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(target)
