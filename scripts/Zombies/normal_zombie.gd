extends CharacterBody2D

var almanac

var speed = 300.0
var health = 100.0
var toughness = 0
var damage = 10

var equipment = []

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
		sprite_2d.texture = load(zombieBase["ImagePath"])


func _process(delta):
	if health <= 0: queue_free()

func _physics_process(delta):
	velocity.x = speed * directionMult

	move_and_slide()


func _on_hit_collide_body_entered(body):
	print(body.name)
	
	if body.get_meta("isTeam1") == false: return
	var damage = body.get_meta("damage")
	
	if toughness > 0:
		toughness -= damage
		if toughness < 0:
			health -= -toughness
	else:
		health -= damage
	
	body.queue_free()
