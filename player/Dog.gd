extends RigidBody2D

const MAX_VEL := 50.0

onready var anim_node := $Anim
onready var sprite_node := $Sprite


func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if input.length_squared() > 1:
		input = input.normalized()

	if input.x < 0:
		sprite_node.scale.x = -1
	elif input.x > 0:
		sprite_node.scale.x = 1
	if input.length_squared() > 0.1:
		anim_node.play("run")
		apply_central_impulse(input * MAX_VEL)
	else:
		anim_node.play("idle")
