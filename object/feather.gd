extends Area2D

@onready var sprite = get_node("Sprite2D")
@onready var animation = $CollectableAnimation

func _on_body_entered(body):
	if body is Penguin:
		_on_collected()
		body.collect_feather()
	
func _on_collected():
	animation.play("collectable_animation")
