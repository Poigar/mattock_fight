extends Node



var weapon_dict = {
	"snowball": "0",
	"knife": "1",
	"mattock": "2"
}

var inventory = {
	"0": 5, # snowballs
	"1": 0, # knives
	"2": 0  # mattocks
}

var current_weapon = 0




func pickup_item(pot):
	
	print("Added "+str(pot.item_amount)+ " "+pot.item_icon)
	inventory[str(weapon_dict[pot.item_icon])] += pot.item_amount
	pot.rpc("empty_pot")
	pot.empty_pot()