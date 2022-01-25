extends Node2D


func _ready():
	if LivesCounter.lives == 3:
		change_env("grass")
	if LivesCounter.lives == 2:
		$Live1.hide()
		change_env("ice")
	if LivesCounter.lives == 1:
		$Live1.hide()
		$Live2.hide()
		change_env("space")
	if LivesCounter.lives == 0:
		LivesCounter.lives = 3
		get_tree().reload_current_scene()
		change_env("grass")

func change_env(env):
	var tile_idx = 2
	var tex = ImageTexture.new()
	var img = Image.new()
	if env == "grass":
		img.load("res://assets/tiles/platform_green_auto.png")
		VisualServer.set_default_clear_color(Color("392946"))
		set_physic_val(1, 1)
	if env == "ice":
		img.load("res://assets/tiles/platform_ice_auto.png")
		VisualServer.set_default_clear_color(Color("0a3558"))
		set_physic_val(1, 0.01)
	if env == "space":
		img.load("res://assets/tiles/platform_space_auto.png")
		VisualServer.set_default_clear_color(Color("483a2f"))
		set_physic_val(0.5, 1)
	tex.create_from_image(img)
	get_parent().get_parent().get_node("TileMap").tile_set.tile_set_texture(tile_idx, tex)
	
	
func set_physic_val(gravity, friction):
	get_parent().get_parent().get_node("Player").set_gravity_scale(gravity)
	get_parent().get_parent().get_node("Player").set_friction(friction)

