extends Path2D
class_name Terrain

@export var Polygon: CollisionPolygon2D
@export var effect_falloff: Curve

const max_modify_distance: float = 500
const min_interval: float = 50
const large: float = 10000

func generate_from_curve(curve: Curve2D) -> void:
	var last_x: float = -min_interval
	var baked_points := curve.get_baked_points()
	var points: PackedVector2Array = PackedVector2Array()
	
	# Add surface points
	for point in baked_points:
		if point.x > last_x + min_interval:
			points.append(point)
			last_x = point.x
	
	# Bottom right corner
	var last_point := points[points.size() - 1]
	last_point.y = large
	points.append(last_point)
	
	# Bottom left corner
	var first_point := points[0]
	first_point.y = large
	points.append(first_point)
	
	Polygon.polygon = points

func _ready() -> void:
	generate_from_curve(curve)

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		apply_gravitation(get_global_mouse_position(), delta)

#func _input(event: InputEvent) -> void:
#	var mouse_input := event as InputEventMouseButton
#	if mouse_input and mouse_input.button_index == MOUSE_BUTTON_LEFT:
#		apply_gravitation(mouse_input.global_position)

func damp(from: float, to: float, smoothing: float, delta: float) -> float:
	return lerp(from, to, 1.0 - pow(smoothing, delta))

func apply_gravitation(global_position: Vector2, delta: float):
	for i in range(0, Polygon.polygon.size() - 2): # last 2 points are the corners
		var point := Polygon.polygon[i]
		var delta_pos := global_position - point
		var dist2 := delta_pos.length_squared()
		if absf(delta_pos.x) < max_modify_distance:
			var effect_amp := 1.0 - absf(delta_pos.x) / max_modify_distance
			effect_amp = effect_falloff.sample(effect_amp)
#			var effect_delta = effect_amp * delta * modify_speed
#			point.y = move_toward(point.y, global_position.y, effect_delta)
			point = Game.damp(point, Vector2(point.x, global_position.y), 0.5 * 2 ** (-5 * effect_amp), delta)
			Polygon.polygon[i] = point
