extends StaticBody2D


var velocity := Vector2()
var acc := Vector2()
var rot := 0.0


func _physics_process(delta: float) -> void:
	rotation += rot * delta
	velocity += acc * delta
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
