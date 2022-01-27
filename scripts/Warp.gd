extends Area2D


export(PackedScene) var level
export(Vector2) var target


func _ready():
	if LivesCounter.lives == 3:
		change_tex("grass")
	if LivesCounter.lives == 2:
		change_tex("ice")
	if LivesCounter.lives == 1:
		change_tex("space")



func change_tex(env):
	var tile_idx = 2
	var tex = ImageTexture.new()
	var img = Image.new()
	if env == "grass":
		img.load("res://assets/objects/warp_pipe.png")
	if env == "ice":
		img.load("res://assets/objects/warp_pipe_ice.png")
	if env == "space":
		img.load("res://assets/objects/warp_pipe_space.png")
	tex.create_from_image(img)
	$SpriteBg.texture.atlas = tex
	$SpriteFg.texture.atlas = tex


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
