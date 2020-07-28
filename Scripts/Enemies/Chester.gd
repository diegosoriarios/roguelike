extends StaticBody2D

var player
var room

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("dash"):
		$AnimationPlayer.play("open")
		yield($AnimationPlayer, "animation_finished")
		$Monster.visible = false
		#$Area2D.queue_free()
		#$AnimationPlayer.queue_free()
		#$Keyboard.queue_free()

func attack():
	if player:
		player.get_hit(1000)

func attack_player(_body):
	pass

func destroy():
	var index = room.enemies.find(self, 0)
	room.enemies.remove(index)
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Keyboard.visible = true
		$Keyboard.play()
		player = body
		body.chest = true
		set_process(true)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Keyboard.visible = false
		$Keyboard.stop()
		body.chest = false
		set_process(false)
