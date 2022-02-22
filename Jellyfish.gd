extends Node2D

var swim_speed = 25
var burst = 0

func _process(delta):
	burst = max(burst-delta, 0)
	self.global_position.y -= (swim_speed + burst) * delta


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "touched":
		$AnimatedSprite.play("default")
		burst = randi()%100+10
	else:
		burst = randi()%50+10


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_TextureButton_pressed():
	$AnimatedSprite.play("touched")
	if randf() > 0.5:
		$Splash1.play()
	else:
		$Splash2.play()
