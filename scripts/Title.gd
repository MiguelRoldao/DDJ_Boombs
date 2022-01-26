extends Node2D



func _ready():
	$Player/Camera2D.current = false
	$Player.hide_ui()
	pass


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/Levels/Level1.tscn")


func _on_TimerStart_timeout():
	$LabelStart.visible = not $LabelStart.visible

