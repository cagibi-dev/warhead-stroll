extends RigidBody2D

var vel := Vector2()
var is_in_danger := false

func _process(_delta: float) -> void:
	# animation
	var acc := vel - linear_velocity
	vel = linear_velocity
	if acc.length_squared() > 100:
		is_in_danger = true
		$Anim.play("danger")
	elif not is_in_danger:
		if vel.length_squared() > 100:
			if vel.x > 1:
				$Sprite.scale.x = 1
			elif vel.x < -1:
				$Sprite.scale.x = -1
			$Anim.play("walk")
		else:
			$Anim.play("idle")


func _on_Anim_animation_finished(_anim_name: String) -> void:
	is_in_danger = false
