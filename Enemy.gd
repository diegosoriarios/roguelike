extends KinematicBody2D

var lives = 20
var isAttacking
var Floating_text = preload("res://FloatingText.tscn")
var Blood  = preload("res://Blood.tscn")
var player
var room

func _ready():
	randomize()

func _physics_process(delta):
	#var areas = get_overlapping_areas()
	
	if isAttacking:
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * 100 * delta)

func hit():
	for i in range(48):
		var blood = Blood.instance()
		get_parent().add_child(blood)
		var angleValue = position.angle_to_point(player.global_position) + deg2rad(i)
		blood.start(position, angleValue) #deg2rad(rand_range(-15, 15)))
	var damage = int(rand_range(1, 10))
	lives -= damage
	
	var floating_text = Floating_text.instance()
	
	floating_text.position = position
	floating_text.velocity = Vector2(rand_range(-50,50), -100)
	floating_text.modulate = Color(rand_range(0.7,1), rand_range(0.7,1), rand_range(0.7,1),1.0)
	
	floating_text.text = str(damage)
	
	get_parent().add_child(floating_text)
	
	if lives <= 0:
		var index = room.enemies.find(self, 0)
		room.enemies.remove(index)
		queue_free()

func attack_player(obj):
	player = obj
	isAttacking = true
