extends Label
class_name FishCounter

var count: int:
	set (value):
		count = value
		text = str(count) + " fish"

func _ready() -> void:
	count = 0
	var penguin := Game.get_penguin()
	if penguin:
		penguin.collected_fish.connect(increment)

func increment() -> void:
	count += 1
