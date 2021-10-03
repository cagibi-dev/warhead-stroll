extends Area2D


export (String, MULTILINE) var text := "ERROR"


func _on_body_entered(_body: Node) -> void:
	Globals.say(text)
	queue_free()
