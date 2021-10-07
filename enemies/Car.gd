extends KinematicBody2D


export (Vector2) var vel := Vector2(0, 500)


func _physics_process(_delta: float) -> void:
	var _a = move_and_slide(vel)
	if position.x > 800:
		position.x -= 1600
	if position.y > 600:
		position.y -= 1200
	if position.x < -800:
		position.x += 1600
	if position.y < -600:
		position.y += 1200


func _on_CrashZone_body_entered(body: Node) -> void:
	if body != self:
		$CrashZone/Crash.play(0.1)
