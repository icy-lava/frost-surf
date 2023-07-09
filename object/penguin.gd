extends CharacterBody2D
class_name Penguin

signal collected_fish

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
const feather_boost: float = 800

@export var Sprite: Sprite2D
@export var boost_curve: Curve

const full_boost_time: float = 0.7
var boost_level: float = 0

func _physics_process(delta: float) -> void:
	# Physics
	velocity.y += gravity * delta
	move_and_slide()
	velocity = get_real_velocity()
	
	# Bounce player away from left border
	if global_position.x < 0:
		velocity.x = abs(velocity.x)
		global_position.x = 0
	
	# Slow down left movement
	if velocity.x < 0:
		velocity.x = Game.dampf(velocity.x, 0, 0.3, delta)
	
	# Water boost
	var in_water := global_position.y > Game.get_water_y()
	boost_level = move_toward(boost_level, 1 if in_water else 0, delta / full_boost_time)
	var boost_level_adjusted = boost_curve.sample_baked(boost_level)
#	modulate = lerp(Color.WHITE, Color.BLUE, boost_level_adjusted)
	velocity.x += 1000 * delta * boost_level_adjusted
	
	# Gradual sprite rotation, based on velocity
	var current_rotation_vector := Vector2.from_angle(Sprite.rotation)
	var target_rotation_vector := velocity.normalized()
	if target_rotation_vector.x < 0:
		target_rotation_vector *= -1
	var new_rotation_vector := Game.damp(current_rotation_vector, target_rotation_vector, 0.01, delta)
	Sprite.rotation = new_rotation_vector.angle()

func collect_item(item: Collectable) -> void:
	match item.kind:
		Collectable.Kind.Fish:
			collected_fish.emit()
		Collectable.Kind.Feather:
			velocity.y = -feather_boost
