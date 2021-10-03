extends Node2D


func _ready() -> void:
	get_tree().paused = false
	Globals.play(preload("res://music/end.ogg"))
	Globals.say("BUTCHER: Way to go Roger! One salami for the dog. Will that be all?\nOLD ROGER: I'll take another one for me if ye will!")
	yield(get_tree().create_timer(7.0), "timeout")
	Globals.say("BUTCHER: Here you go! Have a nice day,\ndon't explode on the way out! OLD ROGER: Thanks, ye too!")
	yield(get_tree().create_timer(9.0), "timeout")
	Globals.say("You died " + str(Globals.deaths)
	+ " times and you finished the game in " + str(round(Globals.time)) + " seconds\nThanks for playing!")
	var err := get_tree().change_scene("res://menu/Title.tscn")
	assert(err == OK)
