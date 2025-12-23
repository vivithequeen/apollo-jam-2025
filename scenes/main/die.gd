extends Control


func _ready():
	start_die()
func start_die():
	$AudioStreamPlayer.play()
	var tween = get_tree().create_tween()
	tween.tween_interval(1.0)
	tween.tween_property($CenterContainer, "modulate:a",1,2)
	tween.parallel();
	tween.tween_property($CenterContainer2, "modulate:a",1,2)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	pass # Replace with function body.
