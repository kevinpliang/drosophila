extends KinematicBody

export var speed = 0.5
export var jump_impulse = 2
export var fall_acceleration = 10.0
export var bounce_impulse = 1.0

var frequency

var direction = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
	pass 

func _physics_process(delta):
	apply_physics(delta)

# Applies motion to kinematic body
func apply_physics(delta) -> void:
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed	
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
