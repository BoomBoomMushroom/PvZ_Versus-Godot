extends Node

@onready var team1Cursor = %Team1Cursor
@onready var team2Cursor = %Team2Cursor
@onready var placement_manager = %PlacementManager

var team1PlaceableX = Vector2(1, 8)
var team2PlaceableX = Vector2(11, 18)

var team1 = []
var team2 = []

func _process(delta):
	var closestTeam1 = getClosest(team1, team1Cursor.position)
	var closestTeam2 = getClosest(team2, team2Cursor.position)
	#print(closest)
	
	if Input.is_action_just_pressed("team1_click") and closestTeam1 != null:
		var team1Cords = closestTeam1.name.split(",")
		var team1X = int(team1Cords[1])
		var team1Y = int(team1Cords[0])
		if team1X >= team1PlaceableX.x and team1X <= team1PlaceableX.y:
			placement_manager.cursorClickTile(team1X, team1Y, true)
	
	if Input.is_action_just_pressed("team2_click") and closestTeam2 != null:
		var team2Cords = closestTeam2.name.split(",")
		var team2X = int(team2Cords[1])
		var team2Y = int(team2Cords[0])
		if team2X >= team2PlaceableX.x and team2X <= team2PlaceableX.y:
			placement_manager.cursorClickTile(team2X, team2Y, false)

func getClosest(teamPoints, center):
	var closest = null
	var closestDist = 999
	
	for i in range(len(teamPoints)):
		var node = teamPoints[i]
		var point = node.position
		node.get_node("Highlight").modulate.a = 0
		
		var dist = sqrt( pow(point.x-center.x,2) + pow(point.y-center.y,2) )
		if dist < closestDist || closest == null:
			closest = node
			closestDist = dist
	
	if closest != null: closest.get_node("Highlight").modulate.a = .75
	return closest

func teamNameFromCursor(cursor):
	var cursorName = cursor.name.split("Cursor")[0]
	return cursorName


func hoverTile(node, cursor):
	var cursorName = teamNameFromCursor(cursor)
	
	if cursorName.to_lower() == "team1":
		team1.append(node)
	elif cursorName.to_lower() == "team2":
		team2.append(node)

func unhoverTile(node, cursor):
	node.get_node("Highlight").modulate.a = 0
	
	var cursorName = teamNameFromCursor(cursor)
	
	if cursorName.to_lower() == "team1":
		team1.remove_at(team1.find(node))
	elif cursorName.to_lower() == "team2":
		team2.remove_at(team2.find(node))
