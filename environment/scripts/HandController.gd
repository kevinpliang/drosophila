extends KinematicBody

var player_position = Vector3.ZERO
var velocity = Vector3.ZERO
var speed = 0.0
var min_speed = 100.0
var max_speed = 150.0

func _ready():
	randomize()
	speed = rand_range(min_speed, max_speed)
	print_debug("hand speed: "+str(speed))
	$AnimationPlayer.playback_speed = 1.25
	$AnimationPlayer.play("smack")
	player_position = get_tree().root.get_node("Main/Player").translation
	#look_at(player_position, Vector3.UP)
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide(velocity)

func _physics_process(_delta):
	player_position = get_tree().root.get_node("Main/Player").translation
	#look_at(player_position, Vector3.UP)
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	velocity = Vector3.FORWARD * speed
	move_and_slide(velocity)

func _on_AnimationPlayer_animation_finished(_anim_name):
	#$AnimationPlayer.play_backwards("smack")
	queue_free()

func _on_Area_body_entered(body):
	print_debug(body.name)
	if body.name == 'Player':
		print_debug("FLY KILLED")
		get_tree().root.get_node("Main/Player/HandTimer").stop()
		get_tree().root.get_node("Main/Player").die()
