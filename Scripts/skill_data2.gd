extends Node

class_name Skill
var title: String
var does_damage: bool
var target_enemy: bool
var target_ally: bool
var target_self: bool
var base_damage: int
var healing: int
var lust_gain: int
var status: Array = []
var damage_type: String #slashing, piercing, bludgeoning, fire, shock, poison, arcane, stress 
var ranged: bool
var aoe: bool
var multihit: int #number of attacks
var description: String
var crit_range: int
var crit_value: float
var cooldown: int
var one_use: bool
var all_allies: bool
var all_enemies: bool
var sex: bool
var special: bool

func _init(title: String, does_damage: bool, target_enemy: bool, target_ally: bool, target_self: bool, base_damage: int, healing: int, lust_gain: int, status: Array, damage_type: String, ranged: bool, aoe: bool, multihit: int, description: String, crit_range: int, crit_value: float, cooldown: int, one_use: bool, all_allies: bool, all_enemies: bool, sex: bool, spare_value: bool):
	self.title = title
	self.does_damage = does_damage
	self.target_enemy = target_enemy
	self.target_ally = target_ally
	self.target_self = target_self
	self.base_damage = base_damage
	self.healing = healing
	self.lust_gain = lust_gain
	self.status = status
	self.damage_type = damage_type #slashing, piercing, bludgeoning, fire, shock, poison, arcane, pleasure
	self.ranged = ranged
	self.aoe = aoe
	self.multihit = multihit #number of attacks 1 is base
	self.description = description
	self.crit_range = crit_range #out of 100
	self.crit_value = crit_value # x1.5 is base
	self.cooldown = cooldown
	self.one_use = one_use
	self.all_allies = all_allies
	self.all_enemies = all_enemies
	self.sex = sex
	self.special = special

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

