extends Node

var players_ready = 0
var networking = null
var private_info = null
var server_info = null
var players = null

var UI = null

var game_started = false

func _ready():
	
	print("Game screen ready")
	
	get_tree().set_pause(true)
	
	networking = get_node("/root/networking")
	private_info = networking.private_info
	players = networking.players
	server_info = networking.server_info
	
	UI = get_node("UI")
	
	if(get_tree().is_network_server()):
		_choose_spawnpoints()





remote func _setup_game(spawnpoints):
	
	print("Start setup")
	
	var player_scene = load("res://scenes/player/Player.tscn")
	
	print("===================")
	print("Private id: " + str(private_info.id))
	print("===================")
	
	for player in players:
		
		var tmp_id = players[player].id
		var spawnpos = get_node("spawnpoints/spawn"+str(spawnpoints[tmp_id])).position
		
		print("Tmp_id: " + str(tmp_id))
		
		var tmp_player = player_scene.instance()
		
		tmp_player.set_name(str(tmp_id))
		tmp_player.position = spawnpos
		tmp_player.set_network_master(tmp_id)
		
		if(tmp_id == get_tree().get_network_unique_id()):
			print("camera setup " + str(tmp_id))
			tmp_player._use_camera(true)
		
		add_child(tmp_player)


	if(!get_tree().is_network_server()):
		rpc_id(1,"_player_ready",private_info.id)
	else:
		_player_ready(private_info.id)







func _choose_spawnpoints():
	
	print("Choose spawnpoints")
	
	var spawnpoints = {}
	
	spawnpoints[1] = 0
	
	var counter = 1
	
	for player in players:
		spawnpoints[players[player].id] = counter
		counter+=1
		
	_setup_game(spawnpoints)
	rpc("_setup_game",spawnpoints)





remote func _player_ready(id):
	
	print("Player ready "+str(id))
	
	players_ready+=1
	if(players_ready == server_info.players_joined):
		_all_ready()
		rpc("_all_ready")





remote func _all_ready():
	print("All ready")
	UI.hide_pregame_msg()
	get_tree().set_pause(false)































