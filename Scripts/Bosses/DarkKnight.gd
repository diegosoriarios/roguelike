extends KinematicBody2D


var Bullet = preload("res://EnemyBullet.tscn")
var bullets = 8
var bullet
var player
var max_hp = 250
var hp = 250
var action = false
var attack_count = 0
var idle = 0
onready var bar = get_parent().find_node("BossUI").find_node("TextureProgress")

func _ready():
	randomize()
	$icon.play("walk")
	$AnimationPlayer.play("walk")
	bar.max_value = max_hp
	update_hp_bar(hp)
	player = get_parent().find_node("Character")


func _process(delta):
	if player.position.x > position.x:
		$icon.flip_h = true
	else:
		$icon.flip_h = false
	
	if !action and $icon.animation != "idle":
		var dir = (player.global_position - global_position).normalized()
		move_and_collide(dir * 50 * delta)
	$aim.look_at(player.position)


func action():
	if idle == 0:
		action = true
		$icon.play("attack")
		$AnimationPlayer.play("attack")
	else:
		idle -= 1

func hit(damage = 10):
	$icon.play("idle")
	$AnimationPlayer.play("idle")
	idle = 1 if randf() > .2 else 0
	hp -= damage
	if hp <= 0:
		queue_free()
	update_hp_bar(hp)

func attack():
	if attack_count == 3:
		for i in range(bullets):
			bullet = Bullet.instance()
			var degree = 360/bullets
			bullet.start(position, $aim.rotation_degrees + deg2rad(degree * i), self, 350)
			get_parent().add_child(bullet)
		attack_count = 0
	else:
		var bodies = $AreaAttack.get_overlapping_bodies()
		
		for body in bodies:
			if body.is_in_group("player"):
				body.get_hit()
		attack_count += 1
	yield($AnimationPlayer, "animation_finished")
	action = false
	$AnimationPlayer.play("walk")
	$icon.play("walk")

func update_hp_bar(value):
	bar.value = value
