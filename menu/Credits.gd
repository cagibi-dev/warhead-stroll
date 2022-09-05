extends Node2D


var step := 0


func _ready() -> void:
	Globals.say_fast(tr("You died ") + str(Globals.deaths)
	+ tr(" times and you finished the game in ") + str(round(Globals.time)) + tr(" seconds\nThank you for playing!"))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() \
	or event is InputEventAction and event.is_pressed():
		next()


func next() -> void:
	match step:
		0:
			$Next.play()
			Globals.say_fast("Thanks to all Ludum Dare reviewers:\nPeace Of Cake Games, gogu, Elastic, Frogman, rogual, Derek Volker,")
		1:
			$Next.play()
			Globals.say_fast("Loudlout, Sipfindel, happ, PetTurtle, hope42morrow,\nJammyGunns, Human Writes Code, gdman, Yerkwell,")
		2:
			$Next.play()
			Globals.say_fast("KuKuRammus, Robonaut121, 13x666, Kongo, rosypenguin,\ngentoogames, Itzemii, Skvader_418, and James_7777")
		3:
			$Next.play()
			Globals.say_fast("Special thanks to DecadeDecaf, CatnipOverdose,\nJamie, and the Godot Engine community!")
		4:
			Globals.say_fast("")
			var err := get_tree().change_scene("res://menu/Title.tscn")
			assert(err == OK)
	step += 1
