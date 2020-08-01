extends Node2D

var Boss = preload("res://Bosses/DarkKnight.tscn")

func _ready():
	var boss = Boss.instance()
	add_child(boss)

func next_room():
	get_tree().change_scene_to(load("res://GameOver.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
