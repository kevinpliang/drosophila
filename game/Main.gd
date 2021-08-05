# This is where we load in the world, player, menus, etc.
extends Spatial

# Scenes to be instanced
onready var player = preload("res://characters/Player.tscn")
onready var world = preload("res://environment/World.tscn")
var world_instance

func _ready():
	Global.main = self
	start_game()
	
func start_game() -> void:
	world_instance = Global.instance_node(world, self)
	Global.instance_node_at(player, Vector3(0, 1, 0), self)
