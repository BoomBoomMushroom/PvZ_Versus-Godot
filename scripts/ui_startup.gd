extends Node

var team1Choices = [
	"Peashooter",
	"Sunflower",
	"Cherry Bomb",
	"Wall-nut",
	"Potato Mine",
	"Chomper",
]

var team2Choices = [
	"Basic Zombie",
	"Conehead Zombie",
	"Buckethead Zombie",
	"Flag Zombie",
	"",
	"",
]

@onready var almanac = %Almanac
@onready var plants_place_ui = %PlantsPlaceUI
@onready var zombie_place_ui = %ZombiePlaceUI

func _ready():
	for i in range(1, 6+1):
		var plantButton = plants_place_ui.get_node("Button" + str(i))
		var zombieButton = zombie_place_ui.get_node("Button" + str(i))
		
		var team1ChoiceName = team1Choices[i-1]
		var team2ChoiceName = team2Choices[i-1]
		
		if team1ChoiceName in almanac.plants:
			var t1Choice = almanac.plants[team1ChoiceName]
			plantButton.get_node("Image").texture = load(t1Choice["ImagePath"])
			plantButton.get_node("Price").text = str(t1Choice["Cost"])
		else:
			plantButton.visible = false
		
		if team2ChoiceName in almanac.zombies:
			var t2Choice = almanac.zombies[team2ChoiceName]
			zombieButton.get_node("Image").texture = load(t2Choice["ImagePath"])
			zombieButton.get_node("Price").text = str(t2Choice["Cost"])
		else:
			zombieButton.visible = false
