extends Area2D

@onready var highlight = $Highlighted
@onready var shadow_bg = $ShadowBg
@onready var image = $Image
@onready var price = $Price

@onready var placement_manager = %PlacementManager

var teamNameLook = ""
var isEntered = false

func _ready():
	image.texture = get_meta("DisplayImage")
	price.text = str(get_meta("Price"))
	teamNameLook = get_meta("CursorToAccept")

func _process(delta):
	var actionName = "team1_click"
	if teamNameLook == "team2": actionName = "team2_click"
	
	if isEntered and Input.is_action_just_pressed(actionName):
		placement_manager.selectButton( get_node("."), teamNameLook=="team1" )

func validCursor(body):
	return teamNameLook in body.name.to_lower()

func setHighlightAlpha(alpha):
	highlight.modulate.a = alpha


func _on_body_entered(body):
	if validCursor(body) == false: return
	
	#print("Hovered by: " + body.name)
	shadow_bg.modulate = Color(0, 0, 0, .25)
	isEntered = true

func _on_body_exited(body):
	if validCursor(body) == false: return
	
	#print("Hover Left by: " + body.name)
	shadow_bg.modulate = Color(0.071, 0.071, 0.071, .25)
	isEntered = false
