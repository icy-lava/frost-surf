extends Label

var count = 0

func _on_penguin_collected_coin():
	count += 1
	text = str(count) + " coins"
