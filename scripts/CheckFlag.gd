extends Area2D


var checked = false


func _ready():
	if Checkpoint.checkpoint == name:
		checked = true

func uncheck():
	$SpriteCloth.visible = false


func check():
	Checkpoint.level = get_tree().current_scene.filename
	Checkpoint.checkpoint = name
	print(Checkpoint.level + " " + Checkpoint.checkpoint)
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

