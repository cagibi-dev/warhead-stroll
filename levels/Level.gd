extends Node2D


var heat := 0.0
var roger_vel := Vector2()
var is_dying := false
export (AudioStream) var music: AudioStream

onready var roger_node := $OldRoger
onready var dog_node := $Dog
onready var bar_node := $HUD/Bar
onready var camera_node := $Camera2D
onready var leash_points := [$Leash/L1, $Leash/L2, $Leash/L3, $Leash/L4, $Leash/L5, $Leash/L6, $Leash/L7, $Leash/L8]


func _ready() -> void:
	Globals.play(music)
	bar_node.show()


func _physics_process(delta: float) -> void:
	update() # trigger redraw

	var roger_acc: Vector2 = roger_node.linear_velocity - roger_vel
	roger_vel += roger_acc
	heat += roger_acc.length_squared() * delta * 1
	heat -= delta * 1 * (heat+1)
	heat = clamp(heat, 0, 100)
	bar_node.value = lerp(bar_node.value, heat, 10 * delta)
	if bar_node.value > 86 and not is_dying:
		is_dying = true
		die()
	
	# kill offscreen
	for protag in [roger_node, dog_node]:
		if protag.position.x > camera_node.limit_right+32 \
		or protag.position.x < camera_node.limit_left-32 \
		or protag.position.y > camera_node.limit_bottom+32 \
		or protag.position.y < camera_node.limit_top-32:
			die()


func _process(delta: float) -> void:
	Globals.time += delta
	camera_node.position = (dog_node.position + roger_node.position) / 2


func _draw() -> void:
	for i in range(len(leash_points)-1):
		draw_line(
			leash_points[i].global_position,
			leash_points[i+1].global_position,
			Color.black, 2, false)


func die() -> void:
	Globals.deaths += 1
	set_physics_process(false)
	$Explosion.position = roger_node.position
	$Explosion/Anim.play("explode")
	roger_node.hide()
	$Explosion/Anim.playback_speed = 20
	dog_node.set_physics_process(false)
	dog_node.anim_node.play("die")
	$Camera2D/ScreenShake.start(0.03, 1000, 20)
	Engine.time_scale = 0.05
	yield(get_tree().create_timer(0.075), "timeout")
	Engine.time_scale = 1.0
	var err := get_tree().reload_current_scene()
	assert(err == OK)
