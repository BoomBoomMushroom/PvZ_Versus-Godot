extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fallSpeed = .01;

var currency_manager
@onready var sprite_2d = $Sprite2D

const SUN_DROP_SPRITE = preload("res://assets/plants/sun_drop.png")
const ZOMBIE_DROP_SPRITE = preload("res://assets/zombie/zombie_drop.png")

func _ready():
	var nameLower = name.to_lower()
	sprite_2d = $Sprite2D
	
	if "team1" in nameLower:
		sprite_2d.texture = SUN_DROP_SPRITE
	elif "team2" in nameLower:
		sprite_2d.texture = ZOMBIE_DROP_SPRITE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = fallSpeed * gravity
		#position.y += fallSpeed * gravity * delta

	move_and_slide()

func _on_collect_body_entered(body):
	# Format Name Like this:
	# TeamX_Y
	# X = team number
	# Y = amount to give
	
	var isTeam1 = false
	var nameSplits = name.split("_")
	if nameSplits[0].to_lower() == "team1": isTeam1 = true
	var correctPicker = false
	
	if isTeam1 and "team1" in body.name.to_lower():
		correctPicker = true
	if isTeam1 == false and "team2" in body.name.to_lower():
		correctPicker = true
	
	if correctPicker == false: return
	
	var amount = int(nameSplits[1])
	
	currency_manager.collectMoney(isTeam1, amount)
	queue_free()
