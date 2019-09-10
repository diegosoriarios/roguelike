extends Area2D

var lives = 2
var isAttacking

func _physics_process(delta):
	var areas = get_overlapping_areas()
	#isAttacking = $".."/Character.attack
	isAttacking = true
	
	for area in areas:
		if area.name == "Sword" and isAttacking:
			self.position.x += rand_range(-32, 32)
			self.position.y += rand_range(-32, 32)
	
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Character":
			$".."/Character.get_hit()