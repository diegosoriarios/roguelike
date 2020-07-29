extends Node2D

var Boss = preload("res://Bosses/DarkKnight.tscn")

func _ready():
	var boss = Boss.instance()
	add_child(boss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
