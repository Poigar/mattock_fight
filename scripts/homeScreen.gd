extends Node

var colorOverlay = null
var joinModal = null
var hostModal = null
var hostModalMsg = null
var joinModalMsg = null

var networking = null

func _ready():
	colorOverlay = get_node("colorOverlay")
	joinModal = get_node("modals/joinModal")
	hostModal = get_node("modals/hostModal")
	hostModalMsg = get_node("modals/hostModal/MC/VBC/msgField")
	
	networking = get_node("/root/networking")
	
	get_node("menu/HBC/VBC/toggleHostModalBtn").connect("pressed", self, "_toggle_host_modal")
	get_node("menu/HBC/VBC/toggleJoinModalBtn").connect("pressed", self, "_toggle_join_modal")

	get_node("modals/hostModal/MC/VBC/closeHostModalBtn").connect("pressed", self, "_toggle_host_modal")
	get_node("modals/joinModal/MC/VBC/closeJoinModalBtn").connect("pressed", self, "_toggle_join_modal")
	
	get_node("modals/hostModal/MC/VBC/hostBtn").connect("pressed", self, "_try_host")
	get_node("modals/joinModal/MC/VBC/joinBtn").connect("pressed", self, "_try_join")
	
	networking.connect("connection_succeeded", self, "_on_connection_success")



func _toggle_host_modal():
	
	if(!hostModal.visible):
		hostModal.show()
		hostModal.get_parent().show()
		colorOverlay.show()
	else:
		hostModal.hide()
		hostModal.get_parent().hide()
		colorOverlay.hide()





func _toggle_join_modal():
	
	if(!joinModal.visible):
		joinModal.show()
		joinModal.get_parent().show()
		colorOverlay.show()
	else:
		joinModal.hide()
		joinModal.get_parent().hide()
		colorOverlay.hide()




func _try_host():
	
	var nickname = hostModal.get_node("MC/VBC/nicknameField").get_text()
	var port = hostModal.get_node("MC/VBC/portField").get_text()
	var ip = hostModal.get_node("MC/VBC/ipField").get_text()
	var max_players = hostModal.get_node("MC/VBC/limitField").get_text()
	
	if(nickname.length() < 3 || (port.length() <3 || port.length() > 6) ):
		_set_modal_msg("HOST", "Invalid details")
		return
	
	if(networking.host(ip,port,max_players,nickname)):
		get_tree().change_scene("res://scenes/lobbyScreen.tscn")
	else:
		_set_modal_msg("HOST", "Cannot host")
		return





func _try_join():
	
	var nickname = joinModal.get_node("MC/VBC/nicknameField").get_text()
	var ip = joinModal.get_node("MC/VBC/ipField").get_text()
	var port = joinModal.get_node("MC/VBC/portField").get_text()
	
	if(nickname.length() < 3 || !ip.is_valid_ip_address() || (port.length() <3 || port.length() > 6)):
		_set_modal_msg("JOIN", "Invalid details")
		return
	
	if(networking.join(ip,port,nickname)):
		_set_modal_msg("JOIN", "Connecting")
	else:
		_set_modal_msg("JOIN", "Cannot join")
		return




func _set_modal_msg(type, msg):
	
	if(type=="HOST"):
		hostModal.get_node("MC/VBC/msgField").set_text(msg)
		
	if(type=="JOIN"):
		joinModal.get_node("MC/VBC/msgField").set_text(msg)

func _on_connection_success():
	pass