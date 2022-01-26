tool
extends ProgressBar


export(Color) var fill_color = Color.blue
export(Color) var bar_color = Color.black
export(Color) var highlight_color = Color.white


func _process(delta):
	var fsb = get_stylebox("fg").duplicate()
	fsb.bg_color = fill_color
	add_stylebox_override("fg", fsb)

	var bsb = get_stylebox("bg").duplicate()
	bsb.border_color = bar_color if value != 100 else highlight_color
	add_stylebox_override("bg", bsb)

