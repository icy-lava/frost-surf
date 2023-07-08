extends Path2D
class_name Terrain

@export var Polygon: CollisionPolygon2D

var min_interval: float = 50
const LARGE: int = 10000

func generate_from_curve(curve: Curve2D) -> void:
	var last_x: float = -min_interval
	var baked_points := curve.get_baked_points()
	var points: PackedVector2Array = PackedVector2Array()
	points.append(Vector2(-LARGE, LARGE))
	for point in baked_points:
		if point.x > last_x + min_interval:
			points.append(point)
			last_x = point.x
	var last_point := points[points.size() - 1]
	last_point.y = LARGE
	points.append(last_point)
	Polygon.polygon = points

func _ready() -> void:
	generate_from_curve(curve)
