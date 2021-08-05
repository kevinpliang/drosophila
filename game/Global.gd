# This is where we will put things that need Global scope
extends Node

# Global instances
var main = null
var player = null

func _process(delta):
	pass

# helper method for creating nodes
func instance_node(node, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance

# helper method for creating node at a specific location 
func instance_node_at(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.translation = location
	return node_instance


