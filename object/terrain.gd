extends Path2D
class_name Terrain

@export var Drawable: Polygon2D
@export var Polygon: CollisionPolygon2D
@export var effect_falloff: Curve

const max_modify_distance: float = 500
const min_interval: float = 50
const large: float = 10000
const mouse_y_margin := 100

const min_crack_interval: float = 400
const max_crack_interval: float = 700

const min_iceberg_interval: float = 800
const max_iceberg_interval: float = 2000

var all_points: PackedVector2Array
var start_x: float
var end_x: float

func generate_from_curve(curve: Curve2D) -> void:
	var last_x: float = -min_interval
	var baked_points := curve.get_baked_points()
	var points: PackedVector2Array = PackedVector2Array()
	
	# Add surface points
	for point in baked_points:
		if point.x >= last_x + min_interval:
			points.append(point)
			last_x = point.x
	start_x = points[0].x
	end_x = points[points.size() - 1].x
	
	# Bottom right corner
	var last_point := points[points.size() - 1]
	last_point.y = large
	points.append(last_point)
	
	# Bottom left corner
	var first_point := points[0]
	first_point.y = large
	points.append(first_point)
	
	Polygon.polygon = points
	Drawable.polygon = points
	
	for child in Drawable.get_children():
		remove_child(child)
	
	var crack_x: float = randf_range(0, min_crack_interval)
	while crack_x < end_x:
		var crack := preload("res://object/crack.tscn").instantiate()
		crack.position.x = crack_x
		Drawable.add_child(crack)
		crack_x += randf_range(min_crack_interval, max_crack_interval)
	
	var iceberg_x: float = randf_range(0, min_iceberg_interval)
	while iceberg_x < end_x:
		var iceberg := preload("res://object/iceberg.tscn").instantiate()
		iceberg.position.x = iceberg_x
		iceberg.position.y = 2160 - 100
		add_child(iceberg)
		iceberg_x += randf_range(min_iceberg_interval, max_iceberg_interval)

func _ready() -> void:
	generate_from_curve(curve)

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		apply_gravitation(get_global_mouse_position(), delta)

func apply_gravitation(global_position: Vector2, delta: float):
	# Limit to what y level we can go
	global_position.y = clamp(global_position.y, 0 + mouse_y_margin, 2160 - mouse_y_margin)
	
	var points := Polygon.polygon.duplicate()
	var min_i: int
	var max_i: int
	for i in range(0, points.size() - 2): # last 2 points are the corners
		var point := points[i]
		var delta_pos := global_position - point
		var dist2 := delta_pos.length_squared()
		if absf(delta_pos.x) < max_modify_distance:
			min_i = mini(min_i, i)
			max_i = maxi(max_i, i)
			var effect_amp := 1.0 - absf(delta_pos.x) / max_modify_distance
			effect_amp = effect_falloff.sample(effect_amp)
			var limit: float = 200
			var diff := clampf(global_position.y - point.y, -limit, limit)
			point.y = Game.dampf(point.y, point.y + diff, 0.5 * 2 ** (-5 * effect_amp), delta)
			points[i] = point
	var range_i := max_i - min_i + 1
	min_i -= range_i / 2
	max_i += range_i / 2
	for i in range(max(min_i, 0), min(max_i, points.size() - 3)):
		var a := points[i]
		var b := points[i + 1]
		var common: float = (a.y + b.y) / 2
		a.y = Game.dampf(a.y, common, 0.1, delta)
		b.y = Game.dampf(b.y, common, 0.1, delta)
		points[i] = a
		points[i + 1] = b
	Polygon.polygon = points
	Drawable.polygon = points
