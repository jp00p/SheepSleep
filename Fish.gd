extends Node2D

var fish_img = 1
var swim_speed = 30
var speed = 1
var pos = Vector2.ZERO
var side = 1

func _ready():
	global_position = pos
	$AnimatedSprite.animation = "fish%s"%fish_img
	speed = swim_speed + rand_range(-2, 2)
	$Bubbles.lifetime = rand_range(3,10)
	$Bubbles.speed_scale = rand_range(0.5,1)
	if side == -1:
		self.scale.x = -1

func _process(delta):
	global_position.x += speed * delta * side


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
