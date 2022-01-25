extends Node


var level = "res://scenes/Levels/Level2.tscn"
var checkpoint = ""
var coordinates = Vector2(0, 0)
var use_coordinates = false

func p():
	print(level + " " + checkpoint)
