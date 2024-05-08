extends Node

var team1Currency = 0
var team2Currency = 0

var sinceLastDrop = 0
var random

@onready var currency_manager = %CurrencyManager
const CURRENCY_DROP_PREFAB = preload("res://scenes/currency_drop.tscn")

const SUN_DROP_SPRITE = preload("res://assets/plants/sun_drop.png")
const ZOMBIE_DROP_SPRITE = preload("res://assets/zombie/zombie_drop.png")

func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()

func _process(delta):
	sinceLastDrop -= delta
	
	if sinceLastDrop < 0:
		sinceLastDrop = randf_range(1, 5)
		
		spawnDrop("Team1", 50)
		spawnDrop("Team2", 50)

func spawnDrop(teamName, value):
	var newDrop = CURRENCY_DROP_PREFAB.instantiate()
	newDrop.position.x = randf_range(-150, 150)
	newDrop.position.y = 0
	newDrop.name = teamName + "_" + str(value)
	newDrop.currency_manager = currency_manager
	
	newDrop.amount = value
	newDrop.isTeam1 = teamName.to_lower() == "team1"
	
	var newTexture = SUN_DROP_SPRITE
	if teamName.to_lower() == "team2": newTexture = ZOMBIE_DROP_SPRITE
	
	newDrop.get_node("Sprite2D").texture = newTexture
	add_child(newDrop)


func collectMoney(isTeam1, amount):
	#print("Collecting " + str(amount) + " for isTeam1: " + str(isTeam1))
	if isTeam1:
		team1Currency += amount
	else:
		team2Currency += amount
