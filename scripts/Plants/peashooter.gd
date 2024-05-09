extends Area2D

@onready var projectileRaycastAndExit = $ProjectileExitHere

var sinceLastShot = 0
var shootCooldown = -1
var projectile = null

var forceShoot = false
var currencyShot = false

func _ready():
	shootCooldown = get_meta("shootCooldown")
	projectile = get_meta("projectile")
	forceShoot = get_meta("forceShoot")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shootCooldown == -1 or projectile == null: return

	sinceLastShot -= delta
	
	# If colliding shoot.
	# it should always collide with a zombie because of the collison mask
	if (forceShoot || projectileRaycastAndExit.is_colliding()) && sinceLastShot <= 0:
			shootProjectile()
			sinceLastShot = shootCooldown

func shootProjectile():
	var newProjectile = projectile.instantiate()
	newProjectile.position = projectileRaycastAndExit.position
	
	if currencyShot:
		newProjectile.set_meta("velocity", Vector2(randf_range(-100, 100), -50))
	else:
		newProjectile.set_meta("damage", 10)
	
	add_child(newProjectile)

