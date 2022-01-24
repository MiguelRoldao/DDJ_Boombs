extends Area2D


var checked = false


func uncheck():
	$SpriteCloth.visible = false


func check():
	$SpriteCloth.visible = true


func uncheck_others(node: Node):
	var array = node.get_children()
	for checkpoint in array:
		if checkpoint.is_in_group("checkpoint"):
			checkpoint.uncheck()


func _on_CheckFlag_body_entered(body: RigidBody2D):
	if not is_instance_valid(body):
		return
	if not body.is_in_group("player"):
		return
	uncheck_others(get_parent())
	check()

