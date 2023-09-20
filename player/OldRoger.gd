extends RigidBody2D

var vel := Vector2()
var is_in_danger := false

onready var anim_node := $Anim
onready var sprite_node := $Sprite


func _process(_delta: float) -> void:
	# animation
	var acc := vel - linear_velocity
	vel = linear_velocity
	if acc.length_squared() > 120:
		is_in_danger = true
		anim_node.play("danger")
	elif not is_in_danger:
		if vel.length_squared() > 100:
			if vel.x > 1:
				sprite_node.scale.x = 1
			elif vel.x < -1:
				sprite_node.scale.x = -1
			anim_node.play("walk")
		else:
			anim_node.play("idle")


func _on_Anim_animation_finished(_anim_name: String) -> void:
	is_in_danger = false
