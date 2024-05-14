extends Area2D

#@onready var projectileRaycastAndExit = $ProjectileExitHere
#@onready var currency_manager = %CurrencyManager
#@onready var almanac = %Almanac

var projectileRaycastAndExit
var currency_manager
var placement_manager
var almanac

# Stats ig
var shootCooldown = -1
var health = 100
var attackDamage = 10
var attackDistance = -1

var sinceLastShot = 0
var projectile = null

var forceShoot = false
var currencyShot = false
var team1Currency = false

var gettingEatenByZombies = []

func _ready():
	projectileRaycastAndExit = get_node("ProjectileExitHere")	
	currency_manager = get_node("/root/Game/Managers/CurrencyManager")
	placement_manager = get_node("/root/Game/Managers/PlacementManager")
	almanac = get_node("/root/Almanac")
	
	
	if get_meta("readMetadata"):
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
		forceShoot = plantData["ForceShoot"]
		attackDistance = plantData["AttackDistance"]
		if plantData["ShootOnSpawn"] == false:
			sinceLastShot = shootCooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		for activeEater in gettingEatenByZombies:
			if activeEater != null: activeEater.releasedFromEatingDuties()
		gettingEatenByZombies = []
		placement_manager.removePlacementAtCords(position)
		queue_free()
	if shootCooldown == -1 or projectile == null: return

	sinceLastShot -= delta
	
	var projectileRaycastColliding = projectileRaycastAndExit.is_colliding()
	
	for zombie in placement_manager.placedZombies:
		var zombiePos = zombie.position
		var dist = sqrt( pow(position.x-zombiePos.x, 2) + pow(position.y-zombiePos.y, 2) )
		if dist <= 15:
			if team1Currency:
				gettingEatenByZombies.append(zombie)
				zombie.youAreNowEatingOpposingTeam(get_node("."))
	
	"""
	if projectileRaycastColliding:
		var colliding = projectileRaycastAndExit.get_collider()
		var collidingPos = colliding.position
		var dist = sqrt( pow(position.x-collidingPos.x, 2) + pow(position.y-collidingPos.y, 2) )
		if dist <= 15:
			if team1Currency:
				gettingEatenByZombies.append(colliding)
				colliding.youAreNowEatingOpposingTeam(get_node("."))
	"""
	
	# If colliding shoot.
	# it should always collide with a zombie because of the collison mask
	if (forceShoot || projectileRaycastColliding) && sinceLastShot <= 0:
		var dist = -1
		if forceShoot == false:
			var colliding = projectileRaycastAndExit.get_collider().position
			dist = sqrt( pow(position.x-colliding.x, 2) + pow(position.y-colliding.y, 2) )
		
		if attackDistance == -1 || dist <= attackDistance:
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
		newProjectile.set_meta("damage", attackDamage)
		newProjectile.set_meta("isTeam1", team1Currency)
		add_child(newProjectile)
	

func takeDamage(damage):
	health -= damage

func _on_body_entered(body):
	if body.get_meta("isTeam1") == team1Currency: return
		
	takeDamage(body.get_meta("damage"))
	body.queue_free()
