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
var shotsFired = 0
var canZombiesEatMe = true

var sinceLastShot = 0
var projectile = null

var forceShoot = false
var currencyShot = false
var team1Currency = false

var almanacLoadName = ""
var plantData = {}

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
	
	almanacLoadName = get_meta("almanacLoadName")
	get_node(".").name = almanacLoadName
	if almanacLoadName != "":
		plantData = almanac.plants[almanacLoadName]
		health = plantData["Health"]
		attackDamage = plantData["AttackDamage"]
		shootCooldown = plantData["AttackRecharge"]
		forceShoot = plantData["ForceShoot"]
		attackDistance = plantData["AttackDistance"]
		canZombiesEatMe = plantData["CanZombiesEatMe"]
		
		var imagePath = plantData["ImagePath"]
		
		if almanacLoadName == "Sunflower" and team1Currency==false:
			imagePath = plantData["ZombieImagePath"]
		
		$Sprite2D.texture = load(imagePath)
		$Sprite2D.scale = Vector2(plantData["ImageScale"], plantData["ImageScale"])
		if plantData["ShootOnSpawn"] == false:
			sinceLastShot = shootCooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		killMyself()
	else:
		if almanacLoadName == "Wall-nut":
			var listOfDamage = plantData["DamagedSpriteList"]
			for damageSprites in listOfDamage:
				var toAndFro = damageSprites["Range"]
				var toHealth = toAndFro[0] * plantData["Health"]
				var froHealth = toAndFro[1] * plantData["Health"]
				
				if health >= toHealth and health < froHealth:
					$Sprite2D.texture = load(damageSprites["Image"])
					break
		elif almanacLoadName == "Potato Mine":
			var imagePath = plantData["ImagePath"]
			if shotsFired >= 1:
				imagePath = plantData["ReadyImagePath"]
			
			$Sprite2D.texture = load(imagePath)
		elif almanacLoadName == "Chomper":
			var imagePath = plantData["ImagePath"]
			if sinceLastShot > 0:
				imagePath = plantData["ChewingImage"]
			
			$Sprite2D.texture = load(imagePath)
	
	updateZombiesEatingMe()

	if shootCooldown == -1: return
	sinceLastShot -= delta
	
	# If colliding shoot.
	# it should always collide with a zombie because of the collison mask
	if (forceShoot || projectileRaycastAndExit.is_colliding()) && sinceLastShot <= 0:
		var dist = -1
		if forceShoot == false:
			var colliding = projectileRaycastAndExit.get_collider().position
			dist = calcDistance(position, colliding)
		
		if attackDistance == -1 || dist <= attackDistance:
			sinceLastShot = shootCooldown
			shootProjectile()

func onMyLevel(pos):
	var myPos = Vector2(position.x, position.y - 8) # adjust for plants position offset
	var diffInY = pos.y - myPos.y
	var dist = calcDistance(myPos, pos)
	if abs(diffInY) >= 16: return false
	return true

func shootProjectile():
	shotsFired += 1
	
	if almanacLoadName == "Chomper":
		var closestZombie = null
		var closestDist = 9 ** 9 # Big because dist should get smaller; would be inf if we had infinity :(
		for zombie in placement_manager.placedZombies:
			if zombie.size > plantData["MaxEatSize"]: continue
			if onMyLevel(zombie.position) == false: continue
			
			var dist = calcDistance(position, zombie.position)
			if closestDist > dist:
				closestZombie = zombie
				closestDist = dist
		
		if closestZombie:
			closestZombie.takeDamage(9 ** 9)
		else:
			sinceLastShot = 0
		
		return
	
	var returnFromExplosion = false
	
	while true:
		# account for the += 1 at the beginning of this function
		if almanacLoadName == "Potato Mine":
			if (shotsFired-1) == 0:
				returnFromExplosion = true
				sinceLastShot = 0
				shootCooldown = 0
				canZombiesEatMe = false
				attackDistance *= 3
				break
			else:
				returnFromExplosion = true
				for zombie in placement_manager.placedZombies:
					if onMyLevel(zombie.position) == false: continue
					
					var dist = calcDistance(position, zombie.position)
					if dist <= plantData["AttackDistance"]:
						returnFromExplosion = false
				if returnFromExplosion: break
		
		if plantData["Projectile"] == "EXPLOSION":
			for zombie in placement_manager.placedZombies:
				var zombiePos = zombie.position
				var dist = calcDistance(position, zombiePos)
				if onMyLevel(zombie.position) == false: continue
				if dist <= attackDistance: # Explosion Radius
					zombie.explode(attackDamage)
			
			var explosionAnimation = projectile.instantiate()
			explosionAnimation.position = position
			explosionAnimation.scaleToSet = 0.5
			
			placement_manager.add_child(explosionAnimation)
			
			killMyself()
			returnFromExplosion = true
		
		break
	if returnFromExplosion: return
	
	if projectile == null: return
	
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

func calcDistance(v1, v2):
	return sqrt( pow(v2.x-v1.x, 2) + pow(v2.y-v1.y, 2) )

func killMyself():
	for activeEater in gettingEatenByZombies:
		if activeEater != null: activeEater.releasedFromEatingDuties()
	gettingEatenByZombies = []
	placement_manager.removePlacementAtCords(position)
	queue_free()

func updateZombiesEatingMe():
	for zombie in placement_manager.placedZombies:
		if canZombiesEatMe == false: break
		
		var zombiePos = zombie.position
		var dist = calcDistance(position, zombiePos)
		if dist <= 15:
			if team1Currency:
				if onMyLevel(zombiePos) == false: continue
				gettingEatenByZombies.append(zombie)
				zombie.youAreNowEatingOpposingTeam(get_node("."))

func takeDamage(damage):
	health -= damage

func _on_body_entered(body):
	if body.get_meta("isTeam1") == team1Currency: return
		
	takeDamage(body.get_meta("damage"))
	body.queue_free()
