extends CharacterBody2D

var almanac

var speed = 300.0
var health = 100.0
var toughness = 0
var damage = 10
var attackSpeed = 1
var size = -1

var equipment = []
var currentEating = null
var sinceLastAttack = 0

var directionMult = -1
@onready var sprite_2d = $Sprite2D

func _ready():
	almanac = get_node("/root/Almanac")
	
	speed = get_meta("speed")
	health = get_meta("health")
	directionMult = get_meta("directionMult")
	
	if get_meta("loadFromName"):
		var zombieBase = almanac.zombies[get_meta("zombieLoad")]
		
		health = zombieBase["Health"]
		speed = zombieBase["Speed"]
		toughness = randf_range(zombieBase["Toughness"].x, zombieBase["Toughness"].y)
		damage = zombieBase["Damage"]
		attackSpeed = zombieBase["AttackSpeed"]
		size = zombieBase["Size"]
		sprite_2d.texture = load(zombieBase["ImagePath"])

func _process(delta):
	if health <= 0: queue_free()
	
	sinceLastAttack -= delta
	
	if currentEating != null:
		if sinceLastAttack <= 0:
			currentEating.takeDamage(damage)
			sinceLastAttack = attackSpeed

func _physics_process(delta):
	var thisTickSpeed = speed
	
	if currentEating != null:
		thisTickSpeed = 0

	velocity.x = thisTickSpeed * directionMult

	move_and_slide()

func youAreNowEatingOpposingTeam(eatingNode):
	if currentEating != null:
		return
	# Node we are eating if we want it ig ¯\_(ツ)_/¯
	print("guess im eating something now!")
	currentEating = eatingNode

func releasedFromEatingDuties():
	# Hey you're free now!
	# Either you were moved out of place or the plant died (shoveled or ate)
	currentEating = null

func takeDamage(damage):
	if toughness > 0:
		toughness -= damage
		if toughness < 0:
			health -= -toughness
	else:
		health -= damage

func explode(explosionDamage):
	takeDamage(explosionDamage)

func _on_hit_collide_body_entered(body):
	if body.get_meta("isTeam1") == false: return
	var damage = body.get_meta("damage")
	
	takeDamage(damage)
	
	body.queue_free()
