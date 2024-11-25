## This Player Style Guide is to be used as reference when programming in GDScript (2.0)!
##
## Functionally, this scene acts as a player node that spawns in and waits a certain amount
## of time before becoming visible and playable. 
##
## File Names: player_style_guide.gd/.tscn
##
## https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
##
#region TL;DR
## NAMING
## - Use PascalCase for Classes, Nodes, and Enums
## - Use snake_case for functions, variables, signals, and file names
## - Use CONSTANT_CASE for constants
##
## COMMENTS
## - ## (double comments) for documentation!
## - #  (single comments) for notes!
## - Use TODO and NOTE often!
##
## SPACING and TABS
## - TWO empty lines between functions
## - ONE tab for indentations
## - TWO tabs for multiline statements
## - Don't exceed the line to the right -------------------------------------------------------------> 
##
## OTHER... STUFF...
## - Use a comma after the final element in an array, dictionary, or enum 
##		(for version control benefits!)
## - "is" does NOT mean "=="! It checks for type!
## - Use "and" and "or instead of && and || for readability. 
#endregion

@tool
class_name PlayerStyleGuide 
extends CharacterBody2D

signal player_spawned	## Emit when a player spawns into the game. 

const SPAWN_TIMEOUT : float = 1.2		## Seconds per spawn. 
const MAX_CURRENCY : int = 1_000_000_005	## Maximum amount of currency a player can hold. 
const CURRENCY_POSTFIX : String = "%d Moneys"

## Cardinal Directions the player can face. 
# NOTE: Use an appending comma on the final item in the array (or dictionary). 
enum Directions {
	UP = 0,	## Up Direction (-y)
	DOWN,	## Down Direction (+y)
	LEFT,	## Left Direction (-x)
	RIGHT,	## Right Direction (+x)
}

## Select which elements (if any) the player has resistance to. 
@export_flags("Fire", "Electricity", "Poison",) var elemental_resistance 

## Configurable direction for the player to start facing at spawn. 
@export var starting_direction : Directions = Directions.UP

## Set the current direction to the configured starting direction on ready. 
@onready var _current_direction : Directions = starting_direction
## Grab the SpawnTimer reference. 
# NOTE: Alternatively, use... _spawn_timer : Timer = $SpawnTimer
@onready var _spawn_timer := get_node("SpawnTimer") as Timer
@onready var _currency_counter := get_node("CurrencyCounter") as Label

## Player's currency. Cannot update currency past the MAX_CURRENCY. 
var currency : int = 0:
	set(new_currency):
		if (new_currency >= MAX_CURRENCY):
			currency = MAX_CURRENCY 
			print("new_currency too large. Capping at MAX_CURRENCY (" + str(MAX_CURRENCY) + ")")
		else:
			currency = new_currency
			print("MAX_CURRENCY not reached! New total currency: " + str(currency))
		_update_currency_label()


func _ready(): 
	_update_currency_label()
	_setup_launch_spawn_timer(1.1)


## Despawns the player (makes them invisible) when called from within or without. 
func despawn_player() -> void: 
	self.visible = false


## Adds currency to the player's running counter. 
func add_currency(add_amount : int) -> void: 
	currency = currency + add_amount


## Cause damage to the player (after any resistances). 
# TODO: Implement a const map for elemental damage types as a global array. 
func take_damage(damage_amount : int, damage_type : int) -> void: 
	var _adjusted_dmg : int = damage_amount
	
	# Check if the player resists the damage type. 
	if (damage_type & elemental_resistance):
		# Player resists this damage, so halve it.
		_adjusted_dmg = floor(damage_amount / 2)
	
	# TODO: Add Health reduction and death handling. 
	pass


## Updates the Currency label on the player node. 
func _update_currency_label() -> void: 
	_currency_counter.text = CURRENCY_POSTFIX % currency
	print("Updated CurrencyCounter string to: " + _currency_counter.text)


## Override the _process function for idle frame processing. 
# NOTE: _delta has an underscore here because it is an overridden parameter that is unused. 
# If you were to use _delta, you should remove the underscore. 
func _process(_delta) -> void:
	if (_current_direction == Directions.DOWN):
		print("Facing Down!")


## Input function to catch player input and translate to facing direction. 
func _input(event) -> void: 
	# TODO: Add handlers for changing _current_direction to an input-mapped direction. 
	# NOTE: This function is unimplemented in order to underscore the importance of comments!
	pass


## Sets up and launches the spawn timer. 
func _setup_launch_spawn_timer(timeout : float = SPAWN_TIMEOUT) -> void: 
	# Set the wait time to the passed timeout (or default to SPAWN_TIMEOUT).
	_spawn_timer.wait_time = timeout
	# This autostart + oneshot set is suboptimal and would generally only be done here if a 
	# new timer was being initialized, rather than the same one being reused. 
	_spawn_timer.autostart = false
	_spawn_timer.one_shot = true
	_spawn_timer.start()


## When the Spawn Timer elapses, emit player_spawned signal. 
func _on_spawn_timer_timeout():
	self.visible = true
	player_spawned.emit()
	print("Player Spawned!")
