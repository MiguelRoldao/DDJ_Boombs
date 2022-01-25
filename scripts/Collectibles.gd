extends Node


var found = 0
var list = {}


func was_collected(path: String):
	return list.has(path)


func add(id: String):
	found += 1
	list[id] = true
	for i in list:
		print("%s : %s" % [i, list[i]])
