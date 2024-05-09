extends Node

# From https://plantsvszombies.fandom.com/wiki/Zombies_(PvZ2)

"""
const toughnessRates = {
	"Fragile" - Absorbs 1-100 damage.
	"Average" - Absorbs 101-200 damage.
	"Solid" - Absorbs 201-320 damage.
	"Protected" - Absorbs 321-600 damage.
	"Dense" - Absorbs 601-1000 damage.
	"Hardened" - Absorbs 1001-1700 damage.
	"Machined" - Absorbs 1701-2500 damage.
	"Great" - Absorbs 2501-8000 damage.
	"Undying": "8001-29500",
	"Ultra-Undying": "29501-30000"
}
"""



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
	"Creeper": 2.133,
	"Stiff": 2.37,
	"Basic": 3.2,
	"Hungry": 4.267,
	"Speedy": 6.4,
	"Flighty": 32,
}

const toughnessRates = {
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
	"Basic Zombie": {"Toughness": toughnessRates["Average"], "Health": 190, "Speed": speeds["Basic"], "Damage": 100},
	"Conehead Zombie": {"Toughness": toughnessRates["Protected"], "Health": 190+370, "Speed": speeds["Basic"], "Damage": 100},
	"Buckethead Zombie": {"Toughness": toughnessRates["Hardened"], "Health": 190+1100, "Speed": speeds["Basic"], "Damage": 100},
	"Flag Zombie": {"Toughness": toughnessRates["Average"], "Health": 190, "Speed": speeds["Basic"], "Damage": 100},
}


# Plants | From https://plantsvszombies.fandom.com/wiki/Plants_(PvZ)

var placeRechargeTime = { # in seconds
	"Fast": 7.5,
	"Slow": 30,
	"Very Slow": 50,
}

var plants = {
	"Peashooter": {"Health": 300, "AttackDamage": 20, "AttackRecharge": 1.425, "SunCost": 100, "PlaceRecharge": placeRechargeTime["Fast"]},
	"Sunflower": {"Health": 300, "AttackDamage": 0, "AttackRecharge": 24.25, "SunCost": 50, "PlaceRecharge": placeRechargeTime["Fast"]},
	"Cherry Bomb": {"Health": -1, "AttackDamage": 1800, "AttackRecharge": 1.2, "SunCost": 150, "PlaceRecharge": placeRechargeTime["Very Slow"]},
	"Wall-nut": {"Health": 4000, "AttackDamage": 0, "AttackRecharge": 0, "SunCost": 50, "PlaceRecharge": placeRechargeTime["Slow"]},
	"Potato Mine": {"Health": 300, "AttackDamage": 1800, "AttackRecharge": 15, "SunCost": 25, "PlaceRecharge": placeRechargeTime["Slow"]},
	"Chomper": {"Health": 300, "AttackDamage": -1, "AttackRecharge": 20, "SunCost": 150, "PlaceRecharge": placeRechargeTime["Fast"]},
}
