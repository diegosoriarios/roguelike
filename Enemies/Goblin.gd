extends KinematicBody2D

export var lives = 25
var isAttacking
var attack = false
var Floating_text = preload("res://FloatingText.tscn")
var player
var got_hit = false
var playerIsClose = null

func _ready():
	$Sprite.play("idle")
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	#var areas = get_overlapping_areas()
	
	if isAttacking:
		if !got_hit and !attack:
			$Sprite.play("walk")
			$AnimationPlayer.play("walk")
		if player.global_position.x > global_position.x:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * 100 * delta)
	else:
		$Sprite.play("idle")
		$AnimationPlayer.play("idle")

func hit_player():
	if player:
		player.get_hit()

func hit():
	got_hit = true
	$Sprite.play("hurt")
	$AnimationPlayer.play("hurt")
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

func attack_player(obj):
	player = obj
	isAttacking = true

func attack():
	if !got_hit:
		print("attack")
		$Sprite.play("attack")
		$AnimationPlayer.play("attack")

func stop_attack():
	if playerIsClose == null:
		attack = false
		$Sprite.play("idle")
		$AnimationPlayer.play("idle")
	else:
		attack()

func stop_hurt():
	$Sprite.play("idle")
	$AnimationPlayer.play("idle")
	#if playerIsClose == null:
	#	$Sprite.play("idle")
	#	$AnimationPlayer.play("idle")
	#else:
	#if playerIsClose != null:
	$Attack.start()
	print($Attack.time_left)

func _on_can_attack():
	print('can_attack')
	got_hit = false
	if playerIsClose:
		attack()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		attack = true
		playerIsClose = body
		attack()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		playerIsClose = null
		stop_attack()
