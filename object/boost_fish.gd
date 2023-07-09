extends RigidBody2D

func _on_collectable_animation_animation_finished(anim_name):
	if anim_name == "collectable_animation":
		queue_free()
