extends Node2D


func _ready() -> void:
	Globals.play(preload("res://music/title.ogg"))
	Globals.time = 0.0
	Globals.deaths = 0
	$Play.grab_focus()


func _on_Play_pressed() -> void:
	var err := get_tree().change_scene("res://levels/Level1.tscn")
	assert(err == OK)


func _on_Sfx_toggled(button_pressed: bool) -> void:
	$Sfx/Toggled.play()
	AudioServer.set_bus_mute(1, not button_pressed)


func _on_Music_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(2, not button_pressed)


func _on_MoreGames_pressed():
	var err := OS.shell_open("https://cagibi.itch.io")
	assert(err == OK)


func _on_Support_pressed():
	var err := OS.shell_open("https://www.buymeacoffee.com/cagibidev")
	assert(err == OK)
