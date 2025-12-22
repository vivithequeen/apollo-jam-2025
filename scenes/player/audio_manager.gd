extends Node

@onready var player = get_parent()
var footstep_sounds = [
	preload("res://resources/sounds/footsteps/footstep1.mp3"),
	preload("res://resources/sounds/footsteps/footstep2.mp3"),
	preload("res://resources/sounds/footsteps/footstep3.mp3"),
	preload("res://resources/sounds/footsteps/footstep4.mp3"),
	preload("res://resources/sounds/footsteps/footstep5.mp3"),
	preload("res://resources/sounds/footsteps/footstep6.mp3"),
] 


func _on_foot_finished():
	return
	$foot.stream = footstep_sounds.pick_random()
	$foot.pitch_scale = randf_range(0.8,1.2)
	$foot.play()

func _on_step_timeout():
	if(!player.is_walking):
		$step.stop()
		return
	$step.wait_time = 0.4 if player.is_sprint else 0.6
	$foot.stream = footstep_sounds.pick_random()
	$foot.pitch_scale = randf_range(0.8,1.2)
	$foot.play()

func begin():
	$foot.stream = footstep_sounds.pick_random()
	$foot.pitch_scale = randf_range(0.8,1.2)
	$foot.play()
	$step.start()
