extends CanvasLayer

var pregame_msg = null


var player_inventory = {
	"0": {
		"id": 0,
		"icon": "",
		"amount": 0
	},
	"2": {
		"id": 0,
		"icon": "",
		"amount": 0
	},
	"3": {
		"id": 0,
		"icon": "",
		"amount": 0
	},
	"4": {
		"id": 0,
		"icon": "",
		"amount": 0
	}
}

var current_slot = 0
var slots = null


func _ready():
	
	slots = get_node("item_slots")
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
	
	
	
	
