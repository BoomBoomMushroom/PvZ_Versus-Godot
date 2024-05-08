extends Node

var team1Currency = 0
var team2Currency = 0

func _ready():
	pass

func collectMoney(isTeam1, amount):
	print("Collecting " + str(amount) + " for isTeam1: " + str(isTeam1))
	if isTeam1:
		team1Currency += amount
	else:
		team2Currency += amount
