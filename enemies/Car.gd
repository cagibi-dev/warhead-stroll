extends KinematicBody2D


export (Vector2) var vel := Vector2(0, 500)


func _physics_process(_delta: float) -> void:
	if position.x > 800:
		position.x -= 1600
	if position.y > 600:
		position.y -= 1200
	if position.x < -800:
		position.x += 1600
	if position.y < -600:
		position.y += 1200
	
	var _a = move_and_slide(vel)


func _on_CrashZone_body_entered(body: Node) -> void:
	if body != self:
		$CrashZone/Crash.play(0.1)
		if body is RigidBody2D:
			body.apply_central_impulse(vel)
