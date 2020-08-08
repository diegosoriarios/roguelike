extends KinematicBody2D

var speed = 500
var velocity = Vector2()

var camera
var init_pos
var stop = false

func start(pos, dir):
	rotation = dir
	position = pos
	init_pos = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	$Timer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Timer.wait_time = rand_range(0, .3)
	$Timer.one_shot = true


func _physics_process(delta):
	if !stop:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit()

func _draw():
	var center = Vector2(200, 200)
	var radius = rand_range(5, 50)#15)
	var color = Color(1.0, 0.0, 0.0)
	draw_circle(center, radius, color)


func _on_Timer_timeout():
	stop = true


func _on_Collision_body_entered(body):
	if body.name == "TileMap":
		queue_free()
		pass
