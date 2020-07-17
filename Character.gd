extends KinematicBody2D

export var id = 0
export var speed = 250
var animationFrame = 0
export var attack = false
var velocity = Vector2()
var lifes = 3
onready var timer = Timer.new()

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		$Sprite.flip_h = false
		$Sprite.play("walk")
		$Sword/Sprite.flip_h = false
		$Sword.position = Vector2(18, 0)
	elif Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		$Sprite.flip_h = true
		$Sprite.play("walk")
		$Sword/Sprite.flip_h = true
		$Sword.position = Vector2(-18, 0)
	elif Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		$Sprite.play("walk")
	elif Input.is_action_pressed('ui_down'):
		velocity.y += 1
		$Sprite.play("walk")
	elif Input.is_action_pressed("attack"):
		attack = true
	#elif Input.is_action_released("attack"):
	#	$Sword.hide()
	else:
		$Sprite.play("idle")
	
	if Input.is_action_just_pressed("dash"):
		dash()
	
	velocity = velocity.normalized() * speed

func dash():
	speed = 1000
	timer.wait_time = .1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", self, "_on_time_out")

func _on_time_out():
	speed = 250
	remove_child(find_node("Timer"))
	print($".".get_children())

func _physics_process(delta):
	get_input()
	
	#Attack
	if attack:
		animationFrame += 1
		$Sword.show()
		if animationFrame == 30:
			attack = false
			animationFrame = 0
			$Sword.hide()
			$Sword/Sprite.rotate(0)
	
	velocity = move_and_slide(velocity)
	
func get_hit():
	lifes -= 1
	self.position.x += rand_range(-32, 32)
	self.position.y += rand_range(-32, 32)
	
