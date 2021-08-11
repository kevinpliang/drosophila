extends Timer

var rng = RandomNumberGenerator.new()
onready var hand = preload("res://environment/Hand.tscn")

func _ready():
	rng.randomize()
	start_rand_timer()

func start_rand_timer():
	wait_time = rng.randf_range(5.0, 7.0)
	self.start()

func _on_HandTimer_timeout():
	Global.instance_node(hand, get_tree().root.get_node("Main/Player"))
	start_rand_timer()


# randomize a time for the hand to smack the fly
# every time the timer goes off, add the hand to the scene
# in the hand scene it will hover over the player  
# if there is a collision, hand splat sound effect, game over 
# on animation finish
#   play "hand remove anim"
#	when that finishes
# 		reset the HandTimer 
#		remove hand from scene
