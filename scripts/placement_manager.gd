extends Node

@onready var almanac = %Almanac
@onready var ui_startup = %UI_Startup
@onready var currency_manager = %CurrencyManager
@onready var plants_place_ui = %PlantsPlaceUI
@onready var zombie_place_ui = %ZombiePlaceUI

const PEA_PROJECTILE = preload("res://scenes/Plants/pea_projectile.tscn")
const CURRENCY_PROJECTILE = preload("res://scenes/currency_drop.tscn")

const PLANT_PREFAB = preload("res://scenes/Plants/peashooter.tscn")
const ZOMBIE_PREFAB = preload("res://scenes/Zombie/normal_zombie.tscn")

var top_left = Vector2.ZERO

var team1ButtonSelected = null
var team2ButtonSelected = null

var placements = ["1,2", "1,5", "18,2", "18,5"]

func _ready():
	top_left = get_meta("topLeft")

func cursorClickTile(x, y, isTeam1):
	if isTeam1 && team1ButtonSelected == null: return
	if isTeam1==false && team2ButtonSelected == null: return
	
	var team2Sunflower = isTeam1==false && team2ButtonSelected.get_meta("itemName") == "Sunflower"
	var isPlacingZombie = team2Sunflower == false and isTeam1==false
	var cordString = str(x) + "," + str(y)
	if cordString in placements and isPlacingZombie == false: return
	
	
	if isTeam1:
		var plantToPlace = team1ButtonSelected.get_meta("itemName")
		var plantData = almanac.plants[plantToPlace]
		if currency_manager.team1Currency >= plantData["Cost"]:
			currency_manager.spendMoney(plantData["Cost"], isTeam1)
		else:
			return
		
		var newPlant = PLANT_PREFAB.instantiate()
		newPlant.set_meta("almanacLoadName", plantToPlace)
		newPlant.position = top_left + Vector2( (x-1) * 16, y * 16 - 8 )
		
		var projectile = null
		if plantData["Projectile"] == "PEA":
			projectile = PEA_PROJECTILE
			newPlant.currencyShot = false
		elif plantData["Projectile"] == "CURRENCY":
			projectile = CURRENCY_PROJECTILE
			newPlant.currencyShot = true
		
		newPlant.projectile = projectile
		newPlant.team1Currency = isTeam1
		
		placements.append(cordString)
		add_child(newPlant)
	elif team2Sunflower:
		var zombieToPlace = team2ButtonSelected.get_meta("itemName")
		var zombieData = almanac.plants[zombieToPlace]
		if currency_manager.team2Currency >= zombieData["Cost"]:
			currency_manager.spendMoney(zombieData["Cost"], isTeam1)
		else:
			return
		
		var newZombiePlant = PLANT_PREFAB.instantiate()
		newZombiePlant.set_meta("almanacLoadName", zombieToPlace)
		newZombiePlant.position = top_left + Vector2( (x-1) * 16, y * 16 - 8 )

		newZombiePlant.projectile = CURRENCY_PROJECTILE
		newZombiePlant.currencyShot = true
		newZombiePlant.team1Currency = isTeam1
		
		placements.append(cordString)
		add_child(newZombiePlant)
	else:
		var zombieToPlace = team2ButtonSelected.get_meta("itemName")
		var zombieData = almanac.zombies[zombieToPlace]
		if currency_manager.team2Currency >= zombieData["Cost"]:
			currency_manager.spendMoney(zombieData["Cost"], isTeam1)
		else:
			return
		
		var newZombie = ZOMBIE_PREFAB.instantiate()
		newZombie.set_meta("zombieLoad", zombieToPlace)
		newZombie.position = top_left + Vector2( (x-1) * 16, y * 16 - 16 )
		
		add_child(newZombie)
	
	#print(str(x) + ", " + str(y) + " - team1=" + str(isTeam1))

func selectButton(buttonNode, isTeam1):
	var prevButton = team1ButtonSelected
	if isTeam1 == false: prevButton = team2ButtonSelected
	
	if buttonNode == prevButton:
		if isTeam1: team1ButtonSelected = null
		else: team2ButtonSelected = null
	else:
		if isTeam1: team1ButtonSelected = buttonNode
		else: team2ButtonSelected = buttonNode
	
	updateButtonVisuals()

func updateButtonVisuals():
	for i in range(1, 6+1): # +1 to get the 6 included
		var plantButtonNode = plants_place_ui.get_node("Button" + str(i))
		var zombieButtonNode = zombie_place_ui.get_node("Button" + str(i))
		
		var plantAlpha = 0
		var zombieAlpha = 0
		
		if plantButtonNode == team1ButtonSelected: plantAlpha = 64
		if zombieButtonNode == team2ButtonSelected: zombieAlpha = 64
		
		plantButtonNode.setHighlightAlpha(plantAlpha)
		zombieButtonNode.setHighlightAlpha(zombieAlpha)

func placePlant(cordX, cordY, plantName, isTeam1Placing):
	var newPlant = PLANT_PREFAB.instantiate()
	newPlant.position = Vector2(
		top_left.x + (cordX * 16),
		top_left.y + (cordY * 16),
	)
	
	newPlant.set_meta("isTeam1", isTeam1Placing)
	newPlant.set_meta("almanacLoadName", plantName)
	
	add_child(newPlant)
