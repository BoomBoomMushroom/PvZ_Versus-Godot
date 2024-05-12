extends Node

@onready var almanac = %Almanac
@onready var plants_place_ui = %PlantsPlaceUI
@onready var zombie_place_ui = %ZombiePlaceUI

const PEA_PROJECTILE = preload("res://scenes/Plants/pea_projectile.tscn")
const CURRENCY_PROJECTILE = preload("res://scenes/currency_drop.tscn")

const PLANT_PREFAB = preload("res://scenes/Plants/peashooter.tscn")

var top_left = Vector2.ZERO

var team1ButtonSelected = null
var team2ButtonSelected = null

func _ready():
	top_left = get_meta("topLeft")

func cursorClickTile(x, y, isTeam1):
	if isTeam1 && team1ButtonSelected == null: return
	if isTeam1==false && team2ButtonSelected == null: return
	
	print(str(x) + ", " + str(y) + " - team1=" + str(isTeam1))
	pass

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
