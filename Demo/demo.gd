## The main scene in the Style Guide Demo by Jacob Foxe. 2024. 
## Link: 
##
## This scene handles basic processing to demonstrate effective style usage. 
class_name Demo extends Node

const CURRENCY_ADD : int = 500_000_002	## Amount added to player's currency with each press. 

var _player : PlayerStyleGuide	## Player Node in the scene. 

func _ready(): 
	_player = $Layer2D.get_child(0)
	if _player != null: 
		print("Grabbed Player: " + str(_player))
	else: 
		print("No Player Found :(")


## Press Currency Add Button to add CURRENCY_ADD to the player's total. 
func _on_add_currency_button_pressed():
	print("\nCurrency Button Pressed. Adding: " + str(CURRENCY_ADD))
	_player.add_currency(CURRENCY_ADD)
