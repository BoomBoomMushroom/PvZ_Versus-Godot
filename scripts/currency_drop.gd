extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fallSpeed = .01;

var currency_manager
var didReady = false
@onready var sprite_2d = $Sprite2D

var amount = 50
var isTeam1 = true

func _ready():
	var nameLower = name.to_lower()
	
	if "team1" in nameLower:
		pass
		#sprite_2d.texture = SUN_DROP_SPRITE
	elif "team2" in nameLower:
		pass
		#sprite_2d.texture = ZOMBIE_DROP_SPRITE

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
	
	"""
	var isTeam1 = false
	var nameSplits = name.split("_")
	if nameSplits[0].to_lower() == "team1": isTeam1 = true
	"""
	
	var correctPicker = false
	
	if isTeam1 and "team1" in body.name.to_lower():
		correctPicker = true
	if isTeam1 == false and "team2" in body.name.to_lower():
		correctPicker = true
	
	if correctPicker == false: return
	
	#var amount = int(nameSplits[1])
	
	currency_manager.collectMoney(isTeam1, amount)
	queue_free()
