extends CharacterBody2D

const SPEED = 100.0
var inputPrefix = "team2"
@onready var sprite_2d = $Sprite2D

func _ready():
	if "team1" in name.to_lower():
		sprite_2d.modulate = Color(0.254, 0.415, 0.752, 1)
		inputPrefix = "team1"
	else:		
		sprite_2d.modulate = Color(0.77, 0.169, 0.169, 1)
		inputPrefix = "team2"

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Click
		pass

	var directionHorizontal = Input.get_axis(inputPrefix + "_left", inputPrefix + "_right")
	var directionVertical = Input.get_axis(inputPrefix + "_up", inputPrefix + "_down")
	if directionHorizontal:
		velocity.x = directionHorizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if directionVertical:
		velocity.y = directionVertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()




