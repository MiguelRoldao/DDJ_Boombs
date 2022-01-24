extends Node2D

var state = false

var color_true = "3fed6f"
var color_false = "ed4f3f"

signal button_pressed(state)

func on_activate():
	state = not state
	$SpriteIndicator.modulate = Color(color_true if state else color_false)
	emit_signal("button_pressed", state)
	
func change_env():
	# in this specific case, the platform auto tile index is 2
	var tile_idx = 2
	var tex = ImageTexture.new()
	var img = Image.new()
	img.load("res://assets/tiles/platform_orange_auto.png")
	tex.create_from_image(img)
	# node path to the tileset
	get_parent().get_node("TileMap").tile_set.tile_set_texture(tile_idx, tex)
