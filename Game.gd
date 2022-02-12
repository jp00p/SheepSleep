extends Node2D

var thread
var rotation_speed = 0.5
var dolph = null
var score = 0 setget set_score

const FISH = preload("res://Fish.tscn")
const JELLY = preload("res://Jellyfish.tscn")

onready var sounds = [$Sounds/Bubble1, $Sounds/Bubble2, $Sounds/Bubble3, $Sounds/Bubble4, $Sounds/Bubble5, $Sounds/Bubble6]

func _ready():
	randomize()
	$FishTimer.wait_time = rand_range(5,10)

func _process(delta):
	$Pivot.rotation += delta * rotation_speed
	

func randombit():
	if randf() <= 0.5:
		return -1
	else:
		return 1

func _on_Detector_area_entered(area):
	area.correct = true
	dolph = area

func _on_Detector_area_exited(area):
	area.correct = false
	dolph = null

func _on_FishTimer_timeout():
	if thread and thread.is_active():
		thread.wait_to_finish()
	else:
		thread = Thread.new()
		thread.start(self, "spawn_school")
		$FishTimer.wait_time = rand_range(5,10)

func spawn_school():
	var school = [randi()%10+1, randi()%10+1, randi()%10+1] # chose 3 types of fish
	var school_speed = rand_range(-20, 20) # set overall speed
	var num_fish = randi()%25+25 # set size
	var side = randombit() # which side
	var spawn
	# choose spawn point
	if side == -1:
		spawn = $RightSpawns.get_child(randi()%$RightSpawns.get_child_count())
	else:
		spawn = $LeftSpawns.get_child(randi()%$LeftSpawns.get_child_count())
	
	# add all the fish!
	for i in range(num_fish):
		var f = FISH.instance()
		f.pos.x = spawn.global_position.x + (randombit() * rand_range(0,42))
		f.pos.y = spawn.global_position.y + (randombit() * rand_range(0,42))
		f.fish_img = school[randi()%school.size()]
		f.swim_speed += school_speed
		f.side = side
		$Fish.call_deferred("add_child", f)

func _exit_tree():
	if thread and thread.is_active():
		thread.wait_to_finish()


func _on_Exit_area_entered(area):
	area.fade_out()


func _on_Entrance_area_entered(area):
	area.fade_in()


func _on_ChangeSpeed_area_entered(area):
	rotation_speed = rand_range(0.3, 0.6)


func _on_TextureButton_pressed():
	if dolph != null:
		if dolph.correct:
			dolph.spin()
			$Sounds/Chime.play()
			dolph.correct = false
			self.score += 1
		else:
			dolph.missed = true
	

func set_score(val):
	score = val
	$Score.text = str(score)


func _on_JellyfishTimer_timeout():
	spawn_jelly()

func spawn_jelly():
	var j = JELLY.instance()
	var spawn = $BottomSpawns.get_child(randi()%$BottomSpawns.get_child_count())
	j.global_position = spawn.global_position
	$Fish.add_child(j)


func _on_BubbleTimer_timeout():
	if randf() > 0.1:
		var s = sounds[randi()%sounds.size()]
		s.play()
