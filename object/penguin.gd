extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var _Sprite: NodePath
@onready var Sprite: Sprite2D = get_node(_Sprite)

func _physics_process(delta: float) -> void:
	# Physics
	velocity.y += gravity * delta
	move_and_slide()
	velocity = get_real_velocity()
	
	# Gradual sprite rotation, based on velocity
	var current_rotation_vector := Vector2.from_angle(Sprite.rotation)
	var target_rotation_vector := velocity.normalized()
	if target_rotation_vector.x < 0:
		target_rotation_vector *= -1
	var new_rotation_vector := Game.damp(current_rotation_vector, target_rotation_vector, 0.01, delta)
	Sprite.rotation = new_rotation_vector.angle()
