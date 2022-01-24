extends Node2D

func _ready():
	LivesCounter.lives = 3
	
func _physics_process(delta):
	if LivesCounter.lives == 2:
		$Live1.hide()
		change_env("ice")
	if LivesCounter.lives == 1:
		$Live2.hide()
		change_env("space")
	if LivesCounter.lives == 0:
		get_tree().reload_current_scene()
		change_env("grass")

func change_env(env):
	var tile_idx = 2
	var tex = ImageTexture.new()
	var img = Image.new()
	if env == "grass":
		img.load("res://assets/tiles/platform_green_auto.png")
	if env == "ice":
		img.load("res://assets/tiles/platform_grey_auto.png")
	if env == "space":
		img.load("res://assets/tiles/platform_orange_auto.png")
	tex.create_from_image(img)
	get_parent().get_parent().get_node("TileMap").tile_set.tile_set_texture(tile_idx, tex)

