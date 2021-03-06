extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("dash"):
		$AnimationPlayer.play("open")
		yield($AnimationPlayer, "animation_finished")
		$Area2D.queue_free()
		$AnimationPlayer.queue_free()
		$Keyboard.queue_free()

func destroy():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Keyboard.visible = true
		$Keyboard.play()
		body.chest = true
		set_process(true)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Keyboard.visible = false
		$Keyboard.stop()
		body.chest = false
		set_process(false)
