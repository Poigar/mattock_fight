extends Sprite

var type = 0
var item_id = 0
var item_info = null

var inspector = null

func _ready():
	_init_item()

func _init_item():
	
	set_texture(load("res://assets/img/items/bag_"+str(type)+".png"))
	
	var db = get_node("/root/item_db").get_db()
	var item = db[""+str(item_id)+""]

	inspector = get_node("inspector")

	inspector.get_node("bag_item").set_texture(load("res://assets/img/items/"+item.icon+".png"))


func open_inspector():
	inspector.show()



func close_inspector():
	inspector.hide()