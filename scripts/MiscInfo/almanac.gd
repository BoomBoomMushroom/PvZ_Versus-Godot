extends Node

# From https://plantsvszombies.fandom.com/wiki/Zombies_(PvZ2)

# 32 speed = 0.5 seconds/tile
# 16 speed = 1 second/tile
# 8 => 2 seconds/tile
# 4 => 4 seconds / tile
# each 1/2 is 2 seconds?
# Calc seconds per square exponent -> log base 2 of seconds = how many divisions
# 16 * 1/(2^(log base 2 of seconds))
# 16 * 1/(pow(2, (log(seconds) / log(2))))

"""
func calcSpeedFromSeconds(seconds):
	return 16 * 1/(pow(2, (log(seconds) / log(2))))


const speeds = {
	"Creeper": calcSpeedFromSeconds(7.5), # Takes 7.5 seconds to move one square.
	"Stiff": calcSpeedFromSeconds(6.75), # Takes 6.75 seconds to move one square.
	"Basic": calcSpeedFromSeconds(5), # Takes 5.0 seconds to move one square.
	"Hungry": calcSpeedFromSeconds(3.75), # Takes 3.75 seconds to move one square.
	"Speedy": calcSpeedFromSeconds(2.5), # Takes 2.5 seconds to move one square.
	"Flighty": calcSpeedFromSeconds(.5), # Takes 0.5 seconds to move one square.
}
"""

const speeds = {
	"NoAI": 0,
	"Creeper": 2.133,
	"Stiff": 2.37,
	"Basic": 3.2,
	"Hungry": 4.267,
	"Speedy": 6.4,
	"Flighty": 32,
}

const toughnessRates = {
	"None": Vector2(0, 0),
	"Fragile": Vector2(1, 100),
	"Average": Vector2(101, 200),
	"Solid": Vector2(201, 320),
	"Protected": Vector2(321, 600),
	"Dense": Vector2(601, 1000),
	"Hardened": Vector2(1001, 1700),
	"Machined": Vector2(1701, 2500),
	"Great": Vector2(2501, 8000),
	"Undying": Vector2(8001, 29500),
	"Ultra-Undying": Vector2(29501, 30000),
}

const zombies = {
	"Target Zombie": {"Toughness": toughnessRates["None"], "Health": 1,
		"Speed": speeds["NoAI"], "Damage": 0, "Cost": 0, "ImagePath": "res://assets/white_pixel.png"},
	"Basic Zombie": {"Toughness": toughnessRates["Average"], "Health": 190,
		"Speed": speeds["Basic"], "Damage": 100, "Cost": 0, "ImagePath": "res://assets/white_pixel.png"},
	"Conehead Zombie": {"Toughness": toughnessRates["Protected"], "Health": 190+370,
		"Speed": speeds["Basic"], "Damage": 100, "Cost": 0, "ImagePath": "res://assets/white_pixel.png"},
	"Buckethead Zombie": {"Toughness": toughnessRates["Hardened"], "Health": 190+1100,
		"Speed": speeds["Basic"], "Damage": 100, "Cost": 0, "ImagePath": "res://assets/white_pixel.png"},
	"Flag Zombie": {"Toughness": toughnessRates["Average"], "Health": 190,
		"Speed": speeds["Flighty"], "Damage": 100, "Cost": 0, "ImagePath": "res://assets/white_pixel.png"},
}

const zombieEquipment = {
	"Cone": {"Health": 370, "PrefabPath": ""},
	"Bucket": {"Health": 1100, "PrefabPath": ""},
}


# Plants | From https://plantsvszombies.fandom.com/wiki/Plants_(PvZ)

const placeRechargeTime = { # in seconds
	"Fast": 7.5,
	"Slow": 30,
	"Very Slow": 50,
}

const plants = {
	"Peashooter": {"Health": 300, "AttackDamage": 20, "AttackRecharge": 1.425, "Cost": 100,
		"PlaceRecharge": placeRechargeTime["Fast"], "Projectile": "PEA", "ForceShoot": false,
		"AttackDistance": -1, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": true},
	
	"Sunflower": {"Health": 300, "AttackDamage": 0, "AttackRecharge": 24.25, "Cost": 50,
		"PlaceRecharge": placeRechargeTime["Fast"], "Projectile": "CURRENCY", "ForceShoot": true,
		"AttackDistance": -1, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": true},
	
	"Cherry Bomb": {"Health": -1, "AttackDamage": 1800, "AttackRecharge": 1.2, "Cost": 150,
		"PlaceRecharge": placeRechargeTime["Very Slow"], "Projectile": "NONE", "ForceShoot": true,
		"AttackDistance": -1, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": false},
	
	"Wall-nut": {"Health": 4000, "AttackDamage": 0, "AttackRecharge": 0, "Cost": 50,
		"PlaceRecharge": placeRechargeTime["Slow"], "Projectile": "NONE", "ForceShoot": false,
		"AttackDistance": -1, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": true},
	
	"Potato Mine": {"Health": 300, "AttackDamage": 1800, "AttackRecharge": 15, "Cost": 25,
		"PlaceRecharge": placeRechargeTime["Slow"], "Projectile": "NONE", "ForceShoot": false,
		"AttackDistance": 8, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": false},
	
	"Chomper": {"Health": 300, "AttackDamage": -1, "AttackRecharge": 20, "Cost": 150,
		"PlaceRecharge": placeRechargeTime["Fast"], "Projectile": "NONE", "ForceShoot": false,
		"AttackDistance": 24, "ImagePath": "res://assets/white_pixel.png", "ShootOnSpawn": true},
}

