extends KinematicBody

export var speed = 0.5
export var jump_impulse = 2
export var fall_acceleration = 10.0
export var bounce_impulse = 1.0

var frequency

var direction = Vector3.ZERO
var velocity = Vector3.ZERO
var females_in_range = 0
var in_mating_dance = false

func _physics_process(delta) -> void:
	get_physics_from_input()
	get_animation_from_physics()
	apply_physics(delta)
	update_label()

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
		
	in_mating_dance = false
	if Input.is_action_pressed("jump") and females_in_range:
		# Mating dance
		in_mating_dance = true
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		# Jump
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
		
	# Plays animation 
	if !is_on_floor():
		play_animation("jump")
	elif in_mating_dance:
		play_animation("jump")
	elif direction != Vector3.ZERO:
		play_animation("walk")
	else:
		$AnimationPlayer.stop()

# Applies motion to kinematic body
func apply_physics(delta) -> void:
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)

# Plays the animation
func play_animation(animation) -> void:
	if ($AnimationPlayer.has_animation(animation)):
		if ($AnimationPlayer.current_animation != animation):
			$AnimationPlayer.play(animation)

# Shows correct label
func update_label() -> void:
	if in_mating_dance:
		Global.main.change_notification("performing mating dance...")
	elif females_in_range:
		Global.main.change_notification("hold [space] to dance")


func die() -> void:
	queue_free()

func _on_InteractRadius_area_entered(area):
	if (area.is_in_group("female")):
		females_in_range += 1

func _on_InteractRadius_area_exited(area):
	if (area.is_in_group("female")):
		females_in_range -= 1
