extends Area2D


export(PackedScene) var level
export(Vector2) var target


func _on_Warp_body_entered(body):
	if not is_instance_valid(body):
		return
	if not body.is_in_group("player"):
		return
	var retval = get_tree().change_scene_to(level)
	if retval != OK:
		print("ERROR: Couldn't warp! code: ", retval)
	Checkpoint.use_coordinates = true
	Checkpoint.coordinates = target
