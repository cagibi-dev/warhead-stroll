extends Node


var deaths := 0
var time := 0.0


func play(stream: AudioStream) -> void:
	if stream != $Music.stream:
		$Music.stop()
		if stream != null:
			$Music.stream = stream
			$Music.play()


func say(text: String) -> void:
	if $Dialog.text != text:
		$Dialog.text = text
		$Dialog.visible_characters = 0
		$Dialog/Timer.start()


func say_fast(text: String) -> void:
	$Dialog.text = text
	$Dialog.percent_visible = 1


func _on_Timer_timeout() -> void:
	$Dialog.visible_characters += 3
	$Dialog/Talk.play()
	if $Dialog.percent_visible >= 1:
		$Dialog/Timer.stop()
