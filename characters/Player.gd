extends KinematicBody

signal hit

export var speed = 0.5
export var jump_impulse = 2
export var fall_acceleration = 10.0
export var bounce_impulse = 1.0

var frequency

var direction = Vector3.ZERO
var velocity = Vector3.ZERO

func _physics_process(delta) -> void:
	get_physics_from_input()
	get_animation_from_physics()
	apply_physics(delta)
	check_for_mobs()

# Gets motion from input
func get_physics_from_input() -> void:
	# idle if nothing pressed
	direction = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1 
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_impulse

# Plays correct animation based on current motion
func get_animation_from_physics() -> void:
	# Pivots fly based on direction moving
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# translation is a property inherent to the player
		$Pivot.look_at(translation - direction, Vector3.UP) 
		$AnimationPlayer.playback_speed = 4.0
	else: 
		$AnimationPlayer.playback_speed = 1.0
		
	# Plays animation (TODO)
	if (!is_on_floor()):
		playAnimation("jump")
	elif (direction != Vector3.ZERO):
		playAnimation("walk")
	else:
		#print("stop!")
		$AnimationPlayer.stop()

# Applies motion to kinematic body
func apply_physics(delta) -> void:
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

# Checks if you are colliding with a mob
func check_for_mobs() -> void:
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash() # can play an animation in this func
				velocity.y = bounce_impulse

# Plays the animation
func playAnimation(animation) -> void:
	if ($AnimationPlayer.has_animation(animation)):
		if ($AnimationPlayer.current_animation != animation):
			$AnimationPlayer.play(animation)

func die() -> void:
	emit_signal("hit")
	queue_free()
	
func _on_MobDetector_body_entered(_body) -> void:
	die()
