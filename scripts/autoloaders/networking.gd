extends Node

var server_info = {
	"ip": "",
	"port": "",
	"max_players": 0,
	"host": "",
	"players_joined": 0
}

var private_info = {
	"id": "",
	"nickname": "",
	"type": ""
}

var players = {}

signal connection_succeeded

func _ready():
	print("Ready networking")
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_ok")
	get_tree().connect("connection_failed",self,"_connected_fail")
	get_tree().connect("server_disconnected",self,"_server_disconnected")





func host(ip,port,max_players,nickname):
	print("Create host")

	private_info.id = 1
	private_info.nickname = nickname
	private_info.type = "host"
	
	server_info.ip = ip
	server_info.port = port
	server_info.max_players = max_players
	server_info.host = nickname
	server_info.players_joined = 1
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.set_bind_ip(ip)
	
	var error = host.create_server(int(port),int(max_players))
	
	if (error!=OK):
		return false
		
	get_tree().set_network_peer(host)
	get_tree().set_meta("network_peer", host)
	
	players[private_info.id] = private_info
	
	return true





func stop_host():
	print("Stop host")
	get_tree().set_network_peer(null)
	get_tree().get_meta("network_peer").close_connection()
	
	clear_session_data()
	
	return true




func join(ip,port,nickname):
	print("Try to join")
	
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	
	var error = host.create_client(ip,int(port))
	
	if(!error == OK):
		return false
	
	print("no error")
	
	get_tree().set_network_peer(host)
	get_tree().set_meta("network_peer", host)

	
	private_info.nickname = nickname
	private_info.type = "client"
	
	return true



func _player_connected(id):
	print("New player connected")
	server_info.players_joined += 1
	rpc("update_server_info",server_info)




func _player_disconnected(id):
	print("Player disconnected")





func _connected_ok():
	print("Player connected")
	private_info.id = get_tree().get_network_unique_id()
	rpc_id(1,"get_server_info",private_info)





func _connected_fail():
	print("Connection failed")





func _server_disconnected():
	print("Server disconnected")
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://scenes/homeScreen.tscn")





remote func get_server_info(new_private_information):
	print("Get server info")
	players[new_private_information.id] = new_private_information
	rpc_id(new_private_information.id,"set_server_info",server_info,players)





remote func set_server_info(server_info_new, players_info):
	print("Set server info")
	server_info = server_info_new
	players = players_info
	get_tree().change_scene("res://scenes/lobbyScreen.tscn")





func disconnect():
	get_tree().set_network_peer(null)
	clear_session_data()





func clear_session_data():
	players = {}
	server_info = {}
	private_info = {}





remote func update_server_info(info):
	print("Update server information")
	server_info = info