extends Area2D

@export var transition: ScreenTransition
@export var transition_scene: PackedScene
@export var current_scene: PackedScene

@export var fishcount: int

@export var fish_counter: FishCounter

func _on_body_entered(body):
	if body is Penguin:
		if fish_counter.count >= fishcount:
			transition.transition(transition_scene)
		else:
			transition.transition(current_scene)
