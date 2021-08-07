# This is where we load in the world, player, menus, etc.
extends Spatial

# Scenes to be instanced
onready var world = preload("res://environment/World.tscn")
onready var player = preload("res://characters/Player.tscn")
onready var female = preload("res://characters/Female.tscn")
var world_instance

func _ready():
	Global.main = self
	start_game()
	
func start_game() -> void:
	world_instance = Global.instance_node(world, self)
	Global.player = Global.instance_node_at(player, Vector3(0, 1, 0), self)
	# Set his frequency here (RNG?)
	Global.player.frequency = 0.5
	spawn_females(10)

# Spawns [number] females at random locations
func spawn_females(number) -> void:
	var x
	var z
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in number:
		x = rng.randf_range(-0.9,0.9)
		z = rng.randf_range(-0.6,0.6)
		Global.instance_node_at(female, Vector3(x,1,z),self)
		
# Changes $UI/Notification to [text]
func change_notification(newText) -> void:
	$UI/Notification.text = newText
