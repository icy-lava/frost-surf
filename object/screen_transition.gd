extends CanvasLayer

signal transitioned

func _ready():
	transition()

func transition():
	$AnimationPlayer.play("fade_to_black")
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		#emit signal after fade_to_black finished
		emit_signal("transition")
		#play fade_to_normal after emitting signal
		$AnimationPlayer.play(("fade_to_normal"))
