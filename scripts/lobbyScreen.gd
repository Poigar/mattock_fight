extends Node

var networking = null
var serverInfo = null
var server_info = null
var msg = null
var playerList = null


func _ready():
	
	msg = get_node("MC/VBC/lowerBar/MC/HBC/msg")
	serverInfo = get_node("MC/VBC/lowerBar/MC/HBC/serverInfo")
	
	networking = get_node("/root/networking")
	server_info = networking.server_info
	
	playerList = get_node("MC/VBC/mainWindow/MC/VBC/playerList")
	serverInfo.set_text("Hosted at "+server_info.ip+":"+server_info.port+" by "+server_info.host)
	
	get_node("MC/VBC/mainWindow/MC/VBC/upperBar/returnBtn").connect("pressed", self, "_exit_lobby")
	get_node("MC/VBC/mainWindow/MC/VBC/upperBar/continueBtn").connect("pressed", self, "_start_game")

	if(networking.private_info.type == "client"):
		_enter_lobby()
	else:
		_refresh_lobby()
		get_node("MC/VBC/mainWindow/MC/VBC/upperBar/continueBtn").show()



func _exit_lobby():
	
	if(get_tree().is_network_server()):
		get_node("MC/VBC/mainWindow/MC/VBC/upperBar/continueBtn").hide()
		networking.stop_host()
		get_tree().change_scene("res://scenes/homeScreen.tscn")
		
	else:
		rpc("remove_player",networking.private_info)
		networking.disconnect()




func _enter_lobby():
	
	networking.players[networking.private_info.id] = networking.private_info
	rpc("register_player",networking.private_info)
	
	_refresh_lobby()





remote func register_player(info):
	networking.players[info.id] = info
	
	_refresh_lobby()





remote func remove_player(info):
	networking.players.erase(info.id)
	_refresh_lobby()





func _refresh_lobby():
	
	var children = playerList.get_node("MarginContainer/VBC").get_children()
	
	for c in children:
		c.queue_free()
	
	for player in networking.players:
		
		var label = Label.new()
		
		if(networking.players[player].type == "host"):
			label.set_text(str(networking.players[player].nickname)+" (HOST)")
		else:
			label.set_text(str(networking.players[player].nickname))
			
		playerList.get_node("MarginContainer/VBC").add_child(label)





func _start_game():
	rpc("_leave_lobby")
	get_tree().change_scene("res://scenes/gameScreen.tscn")





remote func _leave_lobby():
	get_tree().change_scene("res://scenes/gameScreen.tscn")