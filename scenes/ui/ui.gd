extends Control


func show_tooltip(text : String):
	$CenterContainer/tooltip.visible = true;
	$CenterContainer/tooltip.text = text

func hide_tooltip():
	$CenterContainer/tooltip.visible = false;
