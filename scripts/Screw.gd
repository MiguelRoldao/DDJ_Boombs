extends Area2D


func _ready():
	if Collectibles.was_collected(get_path() as String):
		queue_free()

func _on_Node2D_body_entered(body: PhysicsBody2D):
	if not is_instance_valid(body):
		return
	if not body.is_in_group("player"):
		return
	Collectibles.add(get_path())
	body.update_collectibles()
	queue_free()
