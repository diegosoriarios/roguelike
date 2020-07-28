extends RigidBody2D

var size
var enemies = []

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s
	$Area2D/CollisionShape2D.shape = s


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print(body.name)
		for enemy in enemies:
			if body and enemy:
				enemy.attack_player(body)
