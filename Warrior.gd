extends KinematicBody2D

export var id = 0
export var speed = 250
var animationFrame = 0
export var attack = false
var attack_frame = 1
var velocity = Vector2()
var lifes = 3
var bulletNumber = 1

var Bullet = preload('res://Bullet.tscn')

onready var timer = Timer.new()

var face = "right"
var can_dash = true
var mana = 100
var mana_update = false

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		face = "right"
		velocity.x += 1
		$Sprite.flip_h = false
		$weapon_sword.flip_h = true
		$weapon_sword.position = Vector2(0,0)
		#$Sprite.play("walk")
	elif Input.is_action_pressed('ui_left'):
		face = "left"
		velocity.x -= 1
		$Sprite.flip_h = true
		$weapon_sword.flip_h = false
		$weapon_sword.position.x = 36
		#$Sprite.play("walk")
	elif Input.is_action_pressed('ui_up'):
		face = "up"
		velocity.y -= 1
		#$Sprite.play("walk")
	elif Input.is_action_pressed('ui_down'):
		face = "down"
		velocity.y += 1
		#$Sprite.play("walk")
	else:
		#$Sprite.play("idle")
		pass
	
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			dash()
		#attack()
		#if mana > 0:
		#	shoot()
	elif Input.is_action_just_pressed("attack"):
		if !attack:
			attack = true
			$AnimationPlayer.play("attack"+str(attack_frame))
	if Input.is_action_just_released("attack"):
		#$Sword.hide()
		pass
	
	velocity = velocity.normalized() * speed

func attack():
	var colision = null
	if face == "right":
		colision = $Swords/Right
	elif face == "left":
		colision = $Swords/Left
	elif face == "up":
		colision = $Swords/Up
	elif face == "down":
		colision = $Swords/Down
	
	attack_frame += 1
	if attack_frame == 4:
		attack_frame = 1
	
	check_colision(colision)

func stop_attack():
	attack = false

func shoot():
	mana_update = false
	var bullet = Bullet.instance()
	var direction = 0
	if face == "right":
		direction = 0
	elif face == "left":
		direction = deg2rad(180)
	elif face == "up":
		direction = deg2rad(270)
	elif face == "down":
		direction = deg2rad(90)
	"""
	# Bullet 1
	bullet.start(position, direction, self)
	get_parent().add_child(bullet)
	
	# Bullet 2
	var bullet1 = Bullet.instance()
	var bullet2 = Bullet.instance()
	var bullet3 = Bullet.instance()
	bullet1.start(position, direction - deg2rad(15), self)
	bullet2.start(position, direction, self)
	bullet3.start(position, direction + deg2rad(15), self)
	get_parent().add_child(bullet1)
	get_parent().add_child(bullet2)
	get_parent().add_child(bullet3)
	"""
	
	# Bullet 3
	for i in range(bulletNumber):
		bullet = Bullet.instance()
		var degree = 360/bulletNumber
		bullet.start(position, direction - deg2rad(degree * i), self)
		get_parent().add_child(bullet)
		mana -= rand_range(0, 10)
		mana = max(0, mana)
		mana_update = true
		get_parent().find_node("CanvasLayer").find_node("Label").text = "Mana: " + str(mana) 
	
	

func dash():
	can_dash = false
	speed = 500
	#$Sprite.play("roll")
	$AnimationPlayer.play("roll")
	#timer.wait_time = .1
	#timer.one_shot = true
	#timer.set_name("Timer")
	#add_child(timer)
	#timer.start()
	#timer.connect("timeout", self, "_on_dash_time_out")

func on_dash_time_out():
	print("aqui")
	$AnimationPlayer.stop()
	speed = 250
	#for child in get_children():
	#	if child.name == "Timer":
	#		remove_child(child)
	
	var new_timer = Timer.new()
	new_timer.wait_time = .5
	new_timer.one_shot = true
	new_timer.set_name("Dash_Timer")
	add_child(new_timer)
	new_timer.start()
	new_timer.connect("timeout", self, "_on_can_dash_time_out")

func _on_can_dash_time_out():
	can_dash = true
	for child in get_children():
		if child.name == "Dash_Timer":
			remove_child(child)

func _physics_process(delta):
	get_input()
	animate(delta)
	
	#if mana_update:
	#	mana += rand_range(0, 10)
	#	get_parent().find_node("CanvasLayer").find_node("Label").text = "Mana: " + str(floor(mana)) 
	#	mana = min(mana, 100)
	
	velocity = move_and_slide(velocity)
	
func get_hit():
	lifes -= 1
	self.position.x += rand_range(-32, 32)
	self.position.y += rand_range(-32, 32)
	

func check_colision(colision):
	colision.find_node("CollisionShape2D").disabled = false
	var bodies = colision.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies"):
			print(body.name)
			body.hit()

func animate(delta):
	if !can_dash:
		$Sprite.play("roll")
	elif attack:
		$Sprite.play("attack"+str(attack_frame))
	else:
		if Input.is_action_pressed('ui_right') or \
		Input.is_action_pressed('ui_left') or \
		Input.is_action_pressed('ui_up') or \
		Input.is_action_pressed('ui_down'):
			$Sprite.play("walk")
		else:
			$Sprite.play("idle")
