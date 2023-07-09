extends RigidBody2D

func _on_area_2d_body_entered(body):
	if body is Penguin:
		#$AnimationPlayer.play("boulder_off")
		queue_free()
