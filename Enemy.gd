extends KinematicBody2D

var lives = 100
var isAttacking
var Floating_text = preload("res://FloatingText.tscn")

func _physics_process(delta):
	#var areas = get_overlapping_areas()
	
	"""
	#isAttacking = $".."/Character.attack
	#isAttacking = true
	
	for area in areas:
		if area.name == 'Sword' and isAttacking:
			self.position.x += rand_range(-32, 32)
			self.position.y += rand_range(-32, 32)
	
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == 'Character':
			$".."/Character.get_hit()
	
	#for raycast in $Raycasts.get_children():
		
	#	if raycast.is_colliding() and raycast.get_collider().is_in_group('player''):
	#		print(raycast.get_collider().name)
	"""

func hit():
	var damage = int(rand_range(0, 10))
	lives -= damage
	
	var floating_text = Floating_text.instance()
	
	floating_text.position = position
	floating_text.velocity = Vector2(rand_range(-50,50), -100)
	floating_text.modulate = Color(rand_range(0.7,1), rand_range(0.7,1), rand_range(0.7,1),1.0)
	
	floating_text.text = str(damage)
	
	get_parent().add_child(floating_text)
	
	if lives <= 0:
		queue_free()
