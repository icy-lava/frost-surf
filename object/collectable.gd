extends Area2D
class_name Collectable

@export var Anim: AnimationPlayer
@export var Sprite: AnimatedSprite2D

enum Kind {
	None,
	Fish,
	BoostFish,
	Feather
}

@export var kind: Kind = Kind.None

func _ready() -> void:
	assert(kind != Kind.None, "Collectable of Kind.None should never be instantiated")
	set_random_sprite()
	Anim.seek(randf_range(0, Anim.current_animation_length))

func get_sprite_count() -> int:
	if Sprite.sprite_frames:
		return Sprite.sprite_frames.get_frame_count("default")
	return 0

func set_sprite_by_index(i: int) -> void:
	Sprite.frame = i

func set_random_sprite() -> void:
	if get_sprite_count() > 0:
		set_sprite_by_index(randi_range(0, get_sprite_count() - 1))

func _on_body_entered(body):
	var penguin := body as Penguin
	if penguin:
		Anim.play("collectable_animation")
		penguin.collect_item(self)
