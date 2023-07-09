extends Node2D

@export var fish_scene: PackedScene

func _on_fish_spawner_body_entered(body):
	if body is Penguin:
		var fish = fish_scene.instantiate()
		call_deferred("add_child", fish)
