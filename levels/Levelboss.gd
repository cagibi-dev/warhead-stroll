extends "res://levels/Level.gd"


var texts := [
	"BUTCHER: En garde!\nI will fight your dog until death, for a salami.",
	"OLD ROGER: I'm immune to your knives but my dog can get cut.\nOnly the blade parts of the knives can hurt my boy.",
	"OLD ROGER: Ye're a good boy! Keep it up! That's the spirit!\nBUTCHER: This is an absurd conflict and I'm glad to be part of it!",
	"BUTCHER: I've always wondered if every butcher has a fight like\nthis one each morning. OLD ROGER: Ain't bad to have some exercise!",
	"OLD ROGER: Hey butcher, am thinkin there's a metaphor there,\nye know, we're fightin to death for a goddamn salami.",
	"BUTCHER: Yeah, like this is a metaphor for war in general?\nOLD ROGER: Yup. Exactly. Conflit escalation, etc.",
	"OLD ROGER: Anyway, ye have any damn weak points? BUTCHER: Yup.\nOLD ROGER: An' those are? BUTCHER: I won't tell you.",
	"BUTCHER: I just noticed your dog has only 3 legs.\nOLD ROGER: Yeah poor boy. Well he's easier to animate like that.",
	"OLD ROGER: Can I put the credits in there?\nBUTCHER: Bad idea, this text is too short. Focus on the fight.",
	"OLD ROGER: It's a bit cloudy today.\nBUTCHER: Yeah, lots of rain for next week. October I guess.",
	"*knife-throwing noises*\nOLD ROGER: War. War never changes.",
	"OLD ROGER: How many knives ye have?\nBUTCHER: You know, it takes a lot to be a butcher.",
	"BUTCHER: How's the new dog named?\nOLD ROGER: I've not decided. Probably the same as the previous one.",
	"*noise of various cutting objects being thrown*\nBUTCHER: I don't have any special attack for today, sorry.",
	"OLD ROGER: Achoo! BUTCHER: Bless you. OLD ROGER: Thanks.\n*fight continues*",
	"OLD ROGER: Ok this is the last time I'm doin this text thing.\nBUTCHER: Fine, we'll resume chatting after the fight.",
]
var last_attack := 2

onready var boss_bar_node := $HUD/BossBar
onready var barpos: Vector2 = $HUD/BossBar.rect_position
onready var patience: float = $HUD/BossBar.value

func _ready() -> void:
	bar_node.hide()

	var id = -1
	for i in range(len(texts)):
		var text = texts[i]
		if Globals.get_node("Dialog").text == text:
			id = i
			break
	if id < len(texts)-1:
		Globals.say(texts[id+1])


func _process(delta: float) -> void:
	patience -= 2.5*delta
	boss_bar_node.value = patience
	if patience < 15:
		# shaky shaky
		boss_bar_node.rect_position = barpos + Vector2(rand_range(-1, 1), rand_range(-1, 1))
	if patience < 3:
		Globals.say("BUTCHER: Okay fine!\n=== You Win! ===")
		Globals.play(null)
		get_tree().paused = true
		$YouWin.play()
		yield($YouWin, "finished")
		get_tree().paused = false
		var err := get_tree().change_scene_to(preload("res://menu/Ending.tscn"))
		assert(err == OK)


func _on_KnifeTimer_timeout() -> void:
	# never the same twice
	var atk := last_attack
	while atk == last_attack:
		atk = randi()%5
	last_attack = atk

	match atk:
		0:
			rot_knives()
		1:
			border_knives()
		2:
			axes()
		3:
			slicers()
		4:
			rose()


func rot_knives():
	$Aim.position = dog_node.position
	var angle := 0.0
	for _i in range(9):
		var knife: Node2D = preload("res://enemies/Knife.tscn").instance()
		knife.rotation = angle
		knife.position = $Aim.position - Vector2(160, 0).rotated(angle)
		knife.velocity = Vector2(-40, 0).rotated(angle)
		knife.acc = Vector2(160, 0).rotated(angle)
		add_child(knife)
		angle += TAU / 9.0
		yield(get_tree().create_timer(0.1), "timeout")


func border_knives():
	for s in [-1, 1]:
		for i in range(0, 320, 64):
			var knife: Node2D = preload("res://enemies/BigKnife.tscn").instance()
			knife.position = Vector2(256-256*s, i)
			knife.velocity = Vector2(300*s, 0)
			knife.acc = Vector2(-200*s, 0)
			knife.rot = PI*s
			add_child(knife)
			yield(get_tree().create_timer(0.15), "timeout")


func axes():
	for x in [128, 256, 384]:
		var axe: Node2D = preload("res://enemies/Axe.tscn").instance()
		axe.position = Vector2(x, 360 if x == 256 else -40)
		axe.velocity = Vector2(0, -160 if x == 256 else 160)
		axe.acc = Vector2(256-x, 16 if x == 256 else -16)
		axe.rot = PI
		add_child(axe)
		yield(get_tree().create_timer(0.2), "timeout")


func slicers():
	for i in range(7):
		var knife: Node2D = preload("res://enemies/BigKnife.tscn").instance()
		knife.position = Vector2(542 if i%2==0 else -30, 32+40*i)
		knife.rotation = PI if i%2==0 else 0.0
		knife.velocity = Vector2(-250 if i%2==0 else 250, 0)
		add_child(knife)
		yield(get_tree().create_timer(0.25), "timeout")


func rose():
	$Aim.position = dog_node.position
	var angle := 0.0
	for i in range(5):
		var knife: Node2D = preload("res://enemies/Knife.tscn").instance()
		knife.position = $Aim.position - Vector2(160, 0).rotated(angle)
		knife.velocity = Vector2(-25, 0).rotated(angle)
		knife.acc = Vector2(160, 0).rotated(angle)
		knife.rot = TAU if i%2 == 0 else -TAU
		add_child(knife)
		angle += TAU / 5.0
		yield(get_tree().create_timer(0.1), "timeout")


func _on_HitBox_body_entered(_body: Node) -> void:
	if not is_dying:
		is_dying = true
		bar_node.value = 86
		$Explosion.position = dog_node.position
		dog_die()


func dog_die() -> void:
	Globals.deaths += 1
	set_physics_process(false)
	$Explosion.position = dog_node.position
	$Explosion.scale /= 2
	$Explosion/Anim.play("explode")
	$Explosion/Anim.playback_speed = 20
	dog_node.set_physics_process(false)
	dog_node.hide()
	$Camera2D/ScreenShake.start(0.03, 1000, 20)
	Engine.time_scale = 0.05
	yield(get_tree().create_timer(0.075), "timeout")
	Engine.time_scale = 1.0
	var err := get_tree().reload_current_scene()
	assert(err == OK)


func die() -> void:
	pass
