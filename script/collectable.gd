extends Area2D

signal collected

@onready var sprite = get_node("Sprite2D")

func _on_body_entered(body):
	if body is Penguin:
		_on_collected()
	
func _on_collected():
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2.UP * 200, 0.5).as_relative()
	tween.parallel().tween_property(sprite, "modulate", Color(1,1,1,0), 0.5)
	emit_signal("collected")
	queue_free()
	print("COIN!")
	
