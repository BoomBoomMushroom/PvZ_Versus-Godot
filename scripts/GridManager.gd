extends Node

@onready var team1Cursor = %Team1Cursor
@onready var team2Cursor = %Team2Cursor

var team1 = []

func _process(delta):
	print(getClosest(team1, team1Cursor.position))
	pass

func getClosest(teamPoints, center):
	var closest = null
	var closestDist = 999
	
	for i in range(len(teamPoints)):
		var node = teamPoints[i]
		var point = node.position
		var dist = sqrt( pow(point.x-center.x,2) + pow(point.y-center.y,2) )
		if dist < closestDist || closest == null:
			closest = node
			closestDist = dist
	return closest

func teamNameFromCursor(cursor):
	var cursorName = cursor.name.split("Cursor")[0]
	return cursorName


func hoverTile(node, cursor):
	var cursorName = teamNameFromCursor(cursor)
	
	if cursorName.to_lower() == "team1":
		team1.append(node)

func unhoverTile(node, cursor):
	var cursorName = teamNameFromCursor(cursor)
	
	if cursorName.to_lower() == "team1":
		team1.remove_at(team1.find(node))
