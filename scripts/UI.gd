extends CanvasLayer

var pregame_msg = null


func _ready():
	
	set_process_input(true)


func _input(event):
	
	if Input.is_action_just_pressed("ui_fullscreen"):
		print("hello")
		if ! OS.window_fullscreen:
			OS.set_window_fullscreen(true)
			OS.set_borderless_window(true)
		else:
			OS.set_window_fullscreen(false)
			OS.set_borderless_window(false)



func hide_pregame_msg():
	get_node("pregamePanel").hide()
	
	
	
	
	
func show_pregame_msg():
	get_node("pregamePanel").show()
	
	
	
	
