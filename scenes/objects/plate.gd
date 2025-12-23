extends Area3D

var is_blood = true;

var active = false;

func clean_up():
	if(active):
		return

	active = true;
	Memory.items_left -= 1
	var tween = get_tree().create_tween()
	$AudioStreamPlayer3D.play()
	get_tree().call_group("monster","hear_something",global_position)
	tween.tween_property($Mesh,"transparency",0,$AudioStreamPlayer3D.stream.get_length())
	tween.tween_callback(queue_free)
