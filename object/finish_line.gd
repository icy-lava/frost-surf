extends Area2D

@export var transition: ScreenTransition
@export var transition_scene: PackedScene

func _on_body_entered(body):
	if body is Penguin:
		transition.transition(transition_scene)
