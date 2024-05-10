extends Area2D

@onready var projectileRaycastAndExit = $ProjectileExitHere
@onready var currency_manager = %CurrencyManager
@onready var almanac = %Almanac

# Stats ig
var shootCooldown = -1
var health = 100
var attackDamage = 10


var sinceLastShot = 0
var projectile = null

var forceShoot = false
var currencyShot = false
var team1Currency = false

func _ready():
	shootCooldown = get_meta("shootCooldown")
	projectile = get_meta("projectile")
	forceShoot = get_meta("forceShoot")
	currencyShot = get_meta("currencyShot")
	team1Currency = get_meta("isTeam1")
	
	var almanacLoadName = get_meta("almanacLoadName")
	if almanacLoadName != "":
		var plantData = almanac.plants[almanacLoadName]
		health = plantData["Health"]
		attackDamage = plantData["AttackDamage"]
		shootCooldown = plantData["AttackRecharge"]
			

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
	
	
	if currencyShot:
		var teamName = "Team1"
		if team1Currency == false: teamName = "Team2"
		var currencyDrop = currency_manager.spawnDrop(teamName, 50)
		currencyDrop.position = projectileRaycastAndExit.position
		add_child(currencyDrop)
	else:
		var newProjectile = projectile.instantiate()
		newProjectile.position = projectileRaycastAndExit.position
		newProjectile.set_meta("damage", 10)
		add_child(newProjectile)
	
