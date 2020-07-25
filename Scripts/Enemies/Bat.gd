extends KinematicBody2D

var lives = 100
var isAttacking
var attack = false
var Floating_text = preload("res://FloatingText.tscn")
var player
var playerIsClose = null

func _ready():
	$Sprite.play("idle")
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	#var areas = get_overlapping_areas()
	
	if isAttacking:
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * 100 * delta)

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

func attack_player(obj):
	player = obj
	isAttacking = true

func attack():
	$Sprite.play("attack")
	$AnimationPlayer.play("attack")

func stop_attack():
	if playerIsClose == null:
		attack = false
		$Sprite.play("idle")
		$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		attack = true
		playerIsClose = body
		attack()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		playerIsClose = null
		stop_attack()
