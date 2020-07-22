extends KinematicBody2D


var Bullet = preload("res://EnemyBullet.tscn")
var bullets = 8
var bullet

func _ready():
	pass # Replace with function body.


func _process(delta):
	$aim.look_at(get_parent().find_node("Character").position)


func action():
	for i in range(bullets):
		bullet = Bullet.instance()
		var degree = 360/bullets
		bullet.start(position, $aim.rotation_degrees + deg2rad(degree * i), self, 350)
		get_parent().add_child(bullet)
