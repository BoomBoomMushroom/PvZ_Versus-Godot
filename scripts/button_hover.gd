extends Area2D

@onready var highlight = $Highlighted
@onready var shadow_bg = $ShadowBg
@onready var image = $Image
@onready var price = $Price
@onready var cooldownSprite = $Cooldown

@onready var placement_manager = %PlacementManager

var teamNameLook = ""
var isEntered = false

var cooldown = 0
var maxCooldown = -1

func _ready():
	teamNameLook = get_meta("CursorToAccept")

func _process(delta):
	if maxCooldown == -1:
		maxCooldown = get_meta("maxCooldown")
		return
	if visible == false: return
	
	if cooldown > 0:
		cooldown -= delta
		var percent = (cooldown / maxCooldown) + 0.01 # so we dont get a zero width sprite
		cooldownSprite.position.y = 50 * (1-percent)
		cooldownSprite.scale.y = percent
	else:
		cooldown = 0
	
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
