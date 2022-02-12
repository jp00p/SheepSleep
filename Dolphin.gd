extends Area2D

var correct = false
var missed = false

func fade_out():
	$AnimationPlayer.play("fade")
	
func fade_in():
	$AnimationPlayer.play_backwards("fade")

func spin():
	$AnimatedSprite.play("spin")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "spin":
		$AnimatedSprite.play("default")
