extends Sprite

var item_icon = 'snowball'
var item_amount = 5

var inspector = null

func _ready():
	_init_item()

func _init_item():
	
	set_texture(load("res://assets/img/items/pot_0.png"))
	
	inspector = get_node("inspector")
	inspector.get_node("pot_item").set_texture(load("res://assets/img/items/"+item_icon+".png"))


func open_inspector():
	inspector.show()



func close_inspector():
	inspector.hide()




remote func empty_pot():
	print("empty pot")
	item_amount = 0