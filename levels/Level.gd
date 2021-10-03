extends Node2D


var heat := 0.0
var roger_vel := Vector2()
var is_dying := false
export (AudioStream) var music: AudioStream


func _ready() -> void:
	Globals.play(music)
	$HUD/Bar.show()


func _physics_process(delta: float) -> void:
	update() # trigger redraw

	var roger_acc: Vector2 = $OldRoger.linear_velocity - roger_vel
	roger_vel += roger_acc
	heat += roger_acc.length_squared() * delta * 1
	heat -= delta * 1 * (heat+1)
	heat = clamp(heat, 0, 100)
	$HUD/Bar.value = lerp($HUD/Bar.value, heat, 10 * delta)
	if $HUD/Bar.value > 86 and not is_dying:
		is_dying = true
		die()


func _process(delta: float) -> void:
	Globals.time += delta
	$Camera2D.position = ($Dog.position + $OldRoger.position) / 2


func _draw() -> void:
	var j = [$Leash/L1, $Leash/L2, $Leash/L3, $Leash/L4, $Leash/L5, $Leash/L6, $Leash/L7, $Leash/L8]
	for i in range(len(j)-1):
		draw_line(j[i].global_position, j[i+1].global_position, Color.black, 2)


func die() -> void:
	Globals.deaths += 1
	set_physics_process(false)
	$Explosion.position = $OldRoger.position
	$Explosion/Anim.play("explode")
	$OldRoger.hide()
	$Explosion/Anim.playback_speed = 20
	$Dog.set_physics_process(false)
	$Dog/Anim.play("die")
	$Camera2D/ScreenShake.start(0.03, 1000, 20)
	Engine.time_scale = 0.05
	yield(get_tree().create_timer(0.075), "timeout")
	Engine.time_scale = 1.0
	var err := get_tree().reload_current_scene()
	assert(err == OK)
