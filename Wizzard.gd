extends KinematicBody2D

export var id = 0
export var speed = 250
var animationFrame = 0
export var attack = false
var attack_frame = 1
var velocity = Vector2()
var bulletNumber = 1

var Bullet = preload('res://Bullet.tscn')
var Smoke = preload("res://Smoke.tscn")

onready var timer = Timer.new()
onready var hp_bar = get_parent().find_node("CanvasLayer").find_node("HP")
onready var mana_bar = get_parent().find_node("CanvasLayer").find_node("Stamina")

var face = "right"
var can_dash = true
var hp = 100
var mana = 100
var mana_dash_cost = 10
var mana_shoot_cost = 10
var mana_update = false

func _ready():
	update_hp(hp)
	update_mana(mana)

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
	elif Input.is_action_pressed('ui_left'):
		face = "left"
		velocity.x -= 1
		$Sprite.flip_h = true
	elif Input.is_action_pressed('ui_up'):
		face = "up"
		velocity.y -= 1
	elif Input.is_action_pressed('ui_down'):
		face = "down"
		velocity.y += 1
	else:
		#$Sprite.play("idle")
		pass
	
	if Input.is_action_just_pressed("dash"):
		if can_dash and mana - mana_dash_cost >= 0:
			dash()
	elif Input.is_action_just_pressed("attack"):
		if mana - mana_shoot_cost >= 0 and !attack:
			attack = true
			$AnimationPlayer.play("attack"+str(attack_frame))
	#elif Input.is_action_released("attack"):
	#	$Sword.hide()
	
	velocity = velocity.normalized() * speed

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
		var mana_cost = int(rand_range(0, 10))
		mana -= mana_shoot_cost
		mana_update = true
		$ManaUpdate.start()
		update_mana(mana)
		bullet = Bullet.instance()
		var degree = 360/bulletNumber
		bullet.start(position, direction - deg2rad(degree * i), self)
		get_parent().add_child(bullet)

func stop_attack():
	attack_frame += 1
	if attack_frame == 3:
		attack_frame = 1
	attack = false

func dash():
	mana -= mana_dash_cost
	$ManaUpdate.start()
	update_mana(mana)
	var smoke = Smoke.instance()
	smoke.position.x = position.x
	smoke.position.y = position.y
	smoke.find_node("AnimationPlayer").play("start")
	print(smoke.position)
	get_parent().add_child(smoke)
	can_dash = false
	$Sprite.visible = false
	speed = 1000
	timer.wait_time = .2
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", self, "_on_dash_time_out")

func _on_dash_time_out():
	var smoke = Smoke.instance()
	smoke.position.x = position.x
	smoke.position.y = position.y
	smoke.find_node("AnimationPlayer").play("start")
	get_parent().add_child(smoke)
	$Sprite.visible = true
	speed = 250
	remove_child(find_node("Timer"))
	
	var new_timer = Timer.new()
	new_timer.wait_time = .5
	new_timer.one_shot = true
	add_child(new_timer)
	new_timer.start()
	new_timer.connect("timeout", self, "_on_can_dash_time_out")

func _on_can_dash_time_out():
	can_dash = true
	remove_child(find_node("Timer"))

func _physics_process(delta):
	get_input()
	animate(delta)
	
	#if mana_update:
	#	mana += rand_range(0, 10)
	#	get_parent().find_node("CanvasLayer").find_node("Label").text = "Mana: " + str(floor(mana)) 
	#	mana = min(mana, 100)
	
	velocity = move_and_slide(velocity)
	
func get_hit(damage = 10):
	hp -= damage
	self.position.x += rand_range(-32, 32)
	self.position.y += rand_range(-32, 32)

func animate(delta):
	if !can_dash:
		#$Sprite.play("roll")
		pass
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

func update_mana(mana):
	mana_bar.value = mana

func update_hp(hp):
	hp_bar.value = hp


func _on_ManaUpdate_timeout():
	print(mana)
	mana += 2
	update_mana(mana)
	if mana >= 100:
		mana = 100
		mana_update = false
		$ManaUpdate.stop()
