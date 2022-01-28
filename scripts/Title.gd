extends Node2D


export(PackedScene) var level = load("res://scenes/Levels/lvl1.tscn")
export(Vector2) var target = Vector2(-167, -110)


func _ready():
	$Player/Camera2D.current = false
	$Player.hide_ui()
	pass


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if Checkpoint.checkpoint != "":
			get_tree().change_scene(Checkpoint.level)
		else:
			get_tree().change_scene("res://scenes/Levels/lvl1.tscn")


func _on_TimerStart_timeout():
	$LabelStart.visible = not $LabelStart.visible

