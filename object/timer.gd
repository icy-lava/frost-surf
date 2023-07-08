extends Label

var time = 0
var timer_on = false

func _ready():
	start_timer()

func _process(delta):
	if timer_on:
		time += delta
		
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time,60*60)/60

	text = "%02d : %02d : %03d" % [mins,secs,mils]
	
	pass 
	
	
func start_timer():
	timer_on = true
	
func pause_timer():
	timer_on = false
	
func reset_timer():
	time = 0


