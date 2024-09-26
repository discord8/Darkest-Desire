extends Node

class_name goblins
var title: String
var hp: int
var heat: int #chance to use sex attacks 0 is none 10 is orgy time
var attacks: Array
var opportunity_attacks: Array
var sex_attacks: Array
var initiative_average: int
var initiative_roll: int
var status: Array
##var taunt: String #increase lust
#var swarm: String #strength check or be tipped over
# Called when the node enters the scene tree for the first time.
var active_seekers = []
var active_enemies = []
var swarm_stats
var goblin_bucket = []
var in_combat = []
var current_turn = 0
var seeker_turn = false
var show_intia = true
var available_skills = []
func _init():
	self.title = ""
	self.hp = randi_range(400,600)
	self.heat = randi_range(1,5)
	self.attacks = ["Swarm", "Taunt", "Throw Rock", "Hump", "Club", "Pull hair", "Masturbate", "Bite"]
	self.opportunity_attacks = ["Ride Mount", "Ejaculate"]
	self.sex_attacks = ["Blowjob", "Cullingus", "Anilingus", "Breast pull", "Vaginal", "Anal" ]
	self.initiative_average = randi_range(10,45)
	self.initiative_roll = 0
	self.status = []


var did_crit = false
var total_damage
var small_threat = []
var vault_buff
var minor_buff = 5
var moderate_buff = 10
var major_buff = 15
var minor_debuff = 5
var moderate_debuff = 10
var major_debuff = 15

func _ready():
	pass



func Goblin_battle():
	global.clear_seeker_buttons()
	global.main_text.text = "battle against goblins has begun"
	for seeker in global.departing:
		var seeker_inspect = Button.new()
		seeker_inspect.text = seeker.title
		global.button_container.add_child(seeker_inspect)
		seeker_inspect.pressed.connect(Callable(global, "_inspect_departing").bind(seeker))
		global.left_buttons.append(seeker_inspect)
		active_seekers.append(seeker)
	global.departing.clear()
	var goblin_button = Button.new()
	goblin_button.text = "Goblin Patrol"
	global.right_button_container.add_child(goblin_button)
	goblin_button.pressed.connect(Callable(global, "_inspect_goblin"))
	global.right_buttons.append(goblin_button)
	swarm_stats = goblins.new()
	var alive_goblins = swarm_stats.hp/50
	for i in alive_goblins:
		var current_goblin = goblins.new()
		current_goblin.title = "Goblin " + str(i)
		goblin_bucket.append(current_goblin)
	show_intia = true
	roll_initiative()

func roll_initiative():
	in_combat.clear()
	if show_intia == true:
		global.main_text.text = "battle against goblins has begun\n\n"
	var alive_goblins = swarm_stats.hp/5
	while goblin_bucket.size() > alive_goblins:
		goblin_bucket.erase(goblin_bucket[0])
	in_combat.clear()
	for goblin in goblin_bucket:
		goblin.initiative_roll = randi_range(10,45)
		in_combat.append(goblin)
	for seeker in active_seekers:
		seeker.initiative_roll = seeker.agility + randi_range(1,10)
		in_combat.append(seeker)
		print(seeker.skills)
	#in_combat.sort_custom(_sort_by_initiative) cannot get it to work so we going random for now
	in_combat.shuffle()
	show_intia = true
	process_turns()
	

func _sort_by_initiative(a,b):
	return  b.initiative_roll - a.initiative_roll

func process_turns():
	if current_turn >= in_combat.size():  # Reset turns if all turns are completed
		current_turn = 0
		roll_initiative()
	else:
		print(active_seekers)
		var participant = in_combat[current_turn]
		if show_intia == true:
			global.main_text.text = "------------------------\n\n"
			global.main_text.text += "Turn Order\n"
			for i in in_combat:
				global.main_text.text += str(i.title) + "\n"
			global.main_text.text += "\n\n"
			global.main_text.text += "------------------------\n"
			show_intia = false
		seeker_turn = false
		global.clear_seeker_buttons()
		if participant is goblins:
			goblin_turn(participant)
			#in_combat.erase(participant)
		else:  
			global.main_text.text += str(participant.title) + " acts."
			#in_combat.erase(participant)
			player_turn(participant)
			# Seeker-specific behavior
			

func goblin_turn(participant):
	global.main_text.text += str(participant.title) + " goblin takes a turn."
	global.main_text.text += "\n------------------------\n"
	#put goblin logic here
	current_turn += 1
	if current_turn < in_combat.size():
		process_turns()
	else:
		current_turn = 0
		roll_initiative()
	

func player_turn(participant):
	global.clear_seeker_buttons()
	current_turn += 1
	#if sex in status do that instead of regular turn
	var next_turn = Button.new()
	next_turn.text = "Do Nothing"
	global.button_container.add_child(next_turn)
	next_turn.pressed.connect(Callable(self, "process_turns"))
	global.left_buttons.append(next_turn)
	var skill_info = Button.new() #change main text to a description of all current skills by doing for and describing them
	skill_info.text = "Do Nothing"
	global.button_container.add_child(skill_info)
	skill_info.pressed.connect(Callable(self, "skill_info"))
	global.left_buttons.append(skill_info)
	for ability in participant.skill_objects:
		var skill_button = Button.new()
		skill_button.text = ability.title  # 'ability' is a string representing the skill name
		global.button_container.add_child(skill_button)
		skill_button.pressed.connect(Callable(self, "_perform_skill").bind(ability, participant))
		global.left_buttons.append(skill_button)

func _perform_skill(ability, seeker):
	var damage_done
	global.main_text.text = str(seeker.title) +  " uses " + str(ability.title)
	if ability.target_enemy == true:
		if global.right_buttons.size() >= 2:
			global.clear_enemy_buttons()
			for target in active_enemies:
				var seeker_target = Button.new()
				seeker_target.text = target.title
				global.right_button_container.add_child(seeker_target)
				seeker_target.pressed.connect(Callable(self, "skill_logic").bind(ability,seeker,target))
				global.right_buttons.append(seeker_target)
	if ability.target_ally == true:
		global.clear_seeker_buttons()
		for target in active_seekers:
			var seeker_target = Button.new()
			seeker_target.text = target.title
			global.button_container.add_child(seeker_target)
			seeker_target.pressed.connect(Callable(self, "skill_logic").bind(ability,seeker,target))
			global.left_buttons.append(seeker_target)
	if ability.cooldown == 1:
		seeker.skill_objects.erase(ability)
		seeker.cooldown_2.append(ability)
	if ability.cooldown == 2:
		seeker.skill_objects.erase(ability)
		seeker.cooldown_3.append(ability)
	did_crit = false
##so the method to add skills isn't working, i think i fixed them showing up but can't find node, sent the message to the ai so should be fixable

func check_for_crit(ability):
	var d100 = randi_range(1,100)
	if d100 <= ability.crit_range:
		did_crit = true
		

func _target_ally(ability,seeker, target):
	#if "Burn" in ability.status:

	if ability.healing == true:
		check_for_crit(ability)
		swarm_stats.heat += randi_range(1,1)
		if did_crit == true:
			seeker.stamina -= ability.base_damage * ability.crit_value
			if seeker.stamina >= seeker.stamina_max:
				seeker.stamina = seeker.stamina_max
			did_crit = false
		elif did_crit == false:
			swarm_stats.hp -= ability.base_damage
			if seeker.stamina >= seeker.stamina_max:
				seeker.stamina = seeker.stamina_max
	elif ability.lust_gain == true:
		check_for_crit(ability)
		swarm_stats.heat += randi_range(1,3)
		if did_crit == true:
			seeker.stamina -= ability.base_damage * ability.crit_value
			if seeker.stamina >= seeker.stamina_max:
				seeker.stamina = seeker.stamina_max
			did_crit = false
		elif did_crit == false:
			swarm_stats.hp -= ability.base_damage
			if seeker.stamina >= seeker.stamina_max:
				seeker.stamina = seeker.stamina_max


func _ally_special(ability, seeker):
	if ability.title == "Vault":
		vault_buff = seeker #at turn end add this to status after checking for buffs to remove which means its removed at next turn end
		#seeker.status.append("Vaulting")
		seeker.agility += moderate_buff
		if seeker.threat >= 10:
			seeker.threat -= moderate_buff
		else: 
			small_threat.append(seeker.threat)
			seeker.threat -= seeker.threat
			


func skill_logic(ability, seeker, target):
	var damage_done = 0
	#maybe move damage and effects here so that its more modular
	check_for_crit(ability)
	swarm_stats.heat += randi_range(1,3) #if high heat they do scarier actions
	if ability.title == "Multi Slash":
		for i in ability.multihit:
			if did_crit == false:
				damage_done = int(randi_range(0,5) + ability.base_damage)
			else:
				damage_done = int(randi_range(0,5) + ability.base_damage * ability.crit_value)
			swarm_stats.hp -= damage_done
			total_damage += damage_done
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " flies into the Goblin swarm swiftly slicing down their ranks before diving free from any counter attacks. Dealing [color=crimson]" + str(total_damage) + " [/color]total damage."
		total_damage = 0
	if ability.title == "Vital Cut":
		if did_crit == false:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8)
		else:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8 * ability.crit_value)
		swarm_stats.hp -= damage_done
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With precision strikes at a goblins vitals slaying them instantly. Dealing [color=crimson]" + str(damage_done) + " [/color]damage to the horde"
	if ability.title == "Distracting Strike":
		if did_crit == false:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8)
		else:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8 * ability.crit_value)
		swarm_stats.hp -= damage_done
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With an intentionally violent slash a fountain of blood erupts from a slain goblin coating his brothers in crimson. Dealing [color=crimson]" + str(damage_done) + " [/color]damage and distracting the group."
	if ability.title == "Singular Strike":
		if did_crit == false:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8)
		else:
			damage_done = int(randi_range(0,5) + ability.base_damage * 0.8 * ability.crit_value)
		swarm_stats.hp -= damage_done
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " loads a heavy bolt and aims for the central mass of the Goblins penetrating and skewering multiple enemies from the violent impact. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
	if ability.title == "Napalm Bolt":
		swarm_stats.status.append("Burn")
		if did_crit == false:
			damage_done = int(randi_range(0,5) + ability.base_damage * 1.4)
		else:
			damage_done = int(randi_range(0,5) + ability.base_damage * 1.4 * ability.crit_value)
		swarm_stats.hp -= damage_done
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Swiftly modifies her ammo as the goblins lecherously aproaches her, kicking one back after her preperations she dives back while shooting the monster causing a detonation of dire heat and frightining fire, the goblins caught in the blast scream and run about flesh melting away. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
	if ability.title == "Napalm Bolt":
		swarm_stats.heat -= randi_range(3,6)
		if did_crit == false:
			damage_done = int(randi_range(0,5) + ability.base_damage)
		else:
			damage_done = int(randi_range(0,5) + ability.base_damage * ability.crit_value)
		seeker.stamina += damage_done
		if seeker.stamina >= seeker.stamina_max:
			seeker.stamina = seeker.stamina_max
		global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Swiftly modifies her ammo as the goblins lecherously aproaches her, kicking one back after her preperations she dives back while shooting the monster causing a detonation of dire heat and frightining fire, the goblins caught in the blast scream and run about flesh melting away. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
#figure out buffs and debuffs, maybe add them to quirks and have a skill check that they disappear
# - 5 off base damage in global and add in randi_randge 1,5 on dage to see some different damage numbers
