extends "Player.gd"

var waiting = true
var target = Vector3.ZERO

onready var rng = RandomNumberGenerator.new()

func _ready():
	pass

func _physics_process(delta) -> void:
	get_physics_from_input()
	get_animation_from_physics()
	apply_physics(delta)
	check_target()

# Gets proper motion based on target
func get_physics_from_input() -> void:	
	if !waiting:
		direction = translation.direction_to(target)
	else:
		direction = Vector3.ZERO		

# Checks if female has arrived at her target
func check_target() -> void:
	if $WaitTimer.is_stopped() and (abs(translation.x-target.x) < 0.01) and (abs(translation.y-target.y) < 0.01) and (abs(translation.z-target.z) < 0.01):
		$WaitTimer.start()
		waiting = true

# Returns a random nearby coordinate
func randomize_target():
	rng.randomize()
	target = translation + Vector3(rng.randf_range(-0.3,0.3), 0, rng.randf_range(-0.3, 0.3))
	clamp(target.x, -0.9, 0.9)
	clamp(target.z, -0.6, 0.6)

# Changes wait timer wait time to random float
func randomize_wait_timer() -> void:
	rng.randomize()
	$WaitTimer.wait_time = rng.randf_range(2,5)

# When she is done waiting, randomize wait time and target and start moving again
func _on_WaitTimer_timeout():
	randomize_wait_timer()
	randomize_target()	
	waiting = false
