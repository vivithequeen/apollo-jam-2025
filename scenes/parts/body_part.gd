extends Area3D

var is_blood = true;

var active = false;

func clean_up():
	if(active):
		return

	active = true;
	
	var tween = get_tree().create_tween()

	tween.tween_property($Decal,"modulate:a",0,0.5)
	tween.tween_callback(queue_free)
