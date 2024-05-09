extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

"""
	var newDrop = CURRENCY_DROP_PREFAB.instantiate()
	newDrop.position.x = randf_range(-150, 150)
	newDrop.position.y = -150 + randf_range(-10, 10)
	newDrop.name = teamName + "_" + str(value)
	newDrop.currency_manager = currency_manager
	
	newDrop.amount = value
	newDrop.isTeam1 = teamName.to_lower() == "team1"
	
	var newTexture = SUN_DROP_SPRITE
	if teamName.to_lower() == "team2": newTexture = ZOMBIE_DROP_SPRITE
	
	newDrop.get_node("Sprite2D").texture = newTexture
	add_child(newDrop)
"""
