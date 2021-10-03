extends RigidBody2D

var max_vel := 50.0


func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if input.length_squared() > 1:
		input = input.normalized()

	if input.x < 0:
		$Sprite.scale.x = -1
	elif input.x > 0:
		$Sprite.scale.x = 1
	if input.length_squared() > 0.1:
		$Anim.play("run")
	else:
		$Anim.play("idle")

	apply_central_impulse(input * max_vel)
