extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude: float = 0.0
var priority: int = 0

onready var camera: Camera2D = get_parent()
onready var shake_tween: Tween = $ShakeTween

func start(duration: float = 0.2, frequency: float = 20, shake_amplitude: float = 5, shake_priority: int = 0) -> void:
	if shake_priority >= self.priority:
		self.priority = shake_priority
		self.amplitude = shake_amplitude / 2
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()
		
		_new_shake()

func _new_shake() -> void:
	var rand: Vector2 = Vector2.ZERO
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	var _test: bool
	_test = shake_tween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	_test = shake_tween.start()

func _reset() -> void:
	var _test: bool
	_test = shake_tween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, $Frequency.wait_time, TRANS, EASE)
	_test = shake_tween.start()
	
	priority = 0

func _on_Frequency_timeout() -> void:
	_new_shake()

func _on_Duration_timeout() -> void:
	_reset()
	$Frequency.stop()
