extends Node

var tired_points := 0
var jumps_count := 0

var max_tired_points := 100
var money := 100000

# можно расширять бесконечно
var jump_power := 1.0
var income_multiplier := 1.0

var upgrades := {} # id -> level

var world: World
