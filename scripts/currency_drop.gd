extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fallSpeed = .01;

var currency_manager
var didReady = false
@onready var sprite_2d = $Sprite2D

var amount = 50
var isTeam1 = true

var maxY_vel = fallSpeed * gravity

func _ready():
	var nameLower = name.to_lower()
	
	velocity = Vector2(randf_range(-30, 30), -30)
	
	if "team1" in nameLower:
		pass
		#sprite_2d.texture = SUN_DROP_SPRITE
	elif "team2" in nameLower:
		pass
		#sprite_2d.texture = ZOMBIE_DROP_SPRITE

func _physics_process(delta):
	if velocity.y >= maxY_vel:
		velocity.y = maxY_vel
	else:
		velocity.y += maxY_vel * 5 * delta

	velocity.x -= sign(velocity.x) * 10 * delta

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
