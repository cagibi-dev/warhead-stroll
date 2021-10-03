extends Area2D


export (PackedScene) var next_room


func _on_body_entered(_body: Node) -> void:
	$LevelComplete.play()
	get_tree().paused = true
	yield($LevelComplete, "finished")
	get_tree().paused = false
	var err := get_tree().change_scene_to(next_room)
	assert(err == OK)
