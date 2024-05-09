extends Area2D

@onready var shadow_bg = $ShadowBg
@onready var image = $Image
@onready var price = $Price

var teamNameLook = ""

func _ready():
	image.texture = get_meta("DisplayImage")
	price.text = str(get_meta("Price"))
	teamNameLook = get_meta("CursorToAccept")

func validCursor(body):
	return teamNameLook in body.name.to_lower()

func _on_body_entered(body):
	if validCursor(body) == false: return
	
	#print("Hovered by: " + body.name)
	shadow_bg.modulate = Color(0, 0, 0, .25)

func _on_body_exited(body):
	if validCursor(body) == false: return
	
	#print("Hover Left by: " + body.name)
	shadow_bg.modulate = Color(0.071, 0.071, 0.071, .25)
