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
var active_seekers = [] #thos that can act
var all_seekers = [] #all seekers in the mission no matter what statew
var active_enemies = [] 
var knocked_down_seekers = [] #seekers knoicked
var ridden_seekers = [] #seekers ridden
var swarm_stats #main enemy get to 0 hp to win
var goblin_bucket = []
var in_combat = []
var current_turn = 0
var seeker_turn = false
var show_intia = true
var active_turn
func _init():
	self.title = ""
	self.hp = randi_range(250,400)
	self.heat = randi_range(5,10)
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
var main_enemy_container
var main_enemy_health
var main_enemy_heat
var main_enemy_hp_label
var main_enemy_heat_label
var main_enemy
var inspect_current_text = ""

func _ready():
	var current_scene = get_tree().current_scene
	main_enemy = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container/Main_enemy")
	main_enemy_container = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container")
	main_enemy_health = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container/Main_enemy/main_enemy_health")
	main_enemy_heat = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container/Main_enemy/main_enemy_heat")
	main_enemy_hp_label = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container/Main_enemy/main_enemy_health_label")
	main_enemy_heat_label = current_scene.get_node("ColorRect_base/right_side_container/main_enemy_container/Main_enemy/main_enemy_heat_label")


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
		all_seekers.append(seeker)
	global.departing.clear()
	swarm_stats = goblins.new()
	create_swarm(swarm_stats)
	show_intia = true
	roll_initiative()

func roll_initiative():
	var main_text_scroll = global.main_text.get_v_scroll_bar()
	main_text_scroll.value = 0
	in_combat.clear()
	if show_intia == true:
		global.main_text.text = "battle against goblins has begun\n\n"
	var alive_goblins = swarm_stats.hp/40 + 1
	for i in alive_goblins:
		var current_goblin = goblins.new()
		current_goblin.title = "Goblins"
		goblin_bucket.append(current_goblin)
	main_enemy.show()
	while goblin_bucket.size() > alive_goblins:
		goblin_bucket.erase(goblin_bucket[0])
	in_combat.clear()
	for goblin in goblin_bucket:
		in_combat.append(goblin)
	for seeker in active_seekers:
		in_combat.append(seeker)
	for seeker in knocked_down_seekers:
		in_combat.append(seeker)
	for seeker in ridden_seekers:
		in_combat.append(seeker)
	#in_combat.sort_custom(_sort_by_initiative) cannot get it to work so we going random for now
	in_combat.shuffle()
	show_intia = true
	process_turns()
	

func process_turns():
	global.scroll_to_bottom()
	if swarm_stats.hp <= 0:
		global.main_text.text += "The battle has been won!"
		victory()
	elif current_turn >= in_combat.size():  # Reset turns if all turns are completed
		current_turn = 0
		global.clear_seeker_buttons()
		end_round()
	else:
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
			active_turn = participant
			if participant in active_seekers:
				player_turn(participant)
			if participant in knocked_down_seekers:
				knocked_down_seeker_turn(participant)
			if participant in ridden_seekers:
				ridden_turn(participant)
				#have it so that instead of skills they must do a skill check to fight off goblins and if both checks succeed she stands.

func goblin_turn(participant):
	var knocked_index
	var knocked_target
	var active_threat = 0
	var target
	for seeker in active_seekers:
		active_threat += seeker.threat
	var threat_roll = randi_range(1,active_threat)
	for i in active_seekers:
		if i.threat >= threat_roll:
			target = i
			break
		else:
			threat_roll -= i.threat
	var action_choice = randi_range(1,10)
	if knocked_down_seekers.size() >= 1:
		knocked_index = randi_range(0,knocked_down_seekers.size() - 1)
		knocked_target = knocked_down_seekers[knocked_index]
	global.main_text.text += str(participant.title) + " takes a turn.\n\n"
	if action_choice >= 3 and swarm_stats.heat == 20 and knocked_down_seekers.size() >= 1 or action_choice >= 3 and swarm_stats.heat == 0 and knocked_down_seekers.size() >= 1 and knocked_target.stamina > 0:
		target = knocked_target
		var skill_check = randi_range(0,75) #change
		if swarm_stats.heat == 20:
			swarm_stats.heat -= 15
		if swarm_stats.heat == 0:
			swarm_stats.heat += 5
		#make sure to have a general method to free captives, also a loss condition if all seekers are captured, maybe with a special sex scene where the goblins ride there mounts back to their village
		if "Pony Play" in target.fetishes or "Consensual Slave" in target.fetishes or "Spankable Ass" in target.fetishes:
			var potential_memory = randi_range(1,2) #1/4?
			knocked_down_seekers.erase(target)
			ridden_seekers.append(target)
			var gained_lust = randi_range(15,25)
			target.lust += gained_lust
			global.main_text.text += str(participant.title) + " turns " + str(target.title) + " onto all fours, realising where this is going " + str(target.title) + " and shakes her ripe ass back and forth begging the goblin to discipline her. A series of rough spanks causes her arousal to spike and claim her total obedience. The goblin then claws his way up onto her back and whips a bar gag into her mouth that is connected by reigns controling her like a mount in battle. Her heart flutters and her pussy wettens unable to disobey with every spank and excited jerk of the gag she bends to her master's whim gaining [color=hotpink]" + str(gained_lust) + " Lust [/color]."
			if "Spankable Ass" not in target.fetishes and potential_memory == 1 and "Spanked" not in target.memories:
				target.memories.append("Spanked")
				global.main_text.text += "[color=orchid]" + str(target.title) + " dwells on her reddened sore cheeks, feeling the numbing pain radiate through her body, she starts unpacking her opinions. " + str(target.title) + " gained the memory \"Spanked\".[/color]"
			elif "Pony Play" not in target.fetishes and potential_memory == 2 and "Ridden like a pony" not in target.memories:
				target.memories.append("Ridden like a pony")
				global.main_text.text += "\n\n[color=orchid]" + str(target.title) + " through her embarrasment she can't believe shes letting a goblin ride her like an inferior animal. " + str(target.title) + " gained the memory \"Ridden like a pony\".[/color]"
		if target.will <= skill_check:
			knocked_down_seekers.erase(target)
			ridden_seekers.append(target)
			var gained_lust = randi_range(5,15)
			target.lust += gained_lust
			var potential_memory = randi_range(1,2)
			global.main_text.text += str(participant.title) + " turns " + str(target.title) + " onto all fours and thunderously spanks her thick ass causing a shrill shriek followed by lustful recovery breaths. The goblin claws his way up onto her back while shes subdued and whips a bar gag into her mouth that is connected by reigns to control her like a mount in battle. Her heart flutters and her pussy wettens unable to disobey with every spank and excited jerk of the gag she bends to her master's whim gaining [color=hotpink]" + str(gained_lust) + " Lust [/color]."
			update_stamina_lust(target,false,true)
			if "Spankable Ass" not in target.fetishes and potential_memory == 1 and "Spanked" not in target.memories:
				target.memories.append("Spanked")
				global.main_text.text += "\n\n[color=orchid]" + str(target.title) + " dwells on her reddened sore cheeks, feeling the numbing pain radiate through her body, she starts unpacking her opinions. " + str(target.title) + " gained the memory \"Spanked\".[/color]"
			elif "Pony Play" not in target.fetishes and potential_memory == 2 and "Ridden like a pony" not in target.memories:
				target.memories.append("Ridden like a pony")
				global.main_text.text += "\n\n[color=orchid]" + str(target.title) + " through her embarrasment she can't believe shes letting a goblin ride her like an inferior animal. " + str(target.title) + " gained the memory \"Ridden like a pony\".[/color]"
		if target.will >= skill_check:
			var gained_lust = randi_range(5,10)
			target.lust += gained_lust
			global.main_text.text += str(participant.title) + " turns " + str(target.title) + " onto all fours and thunderously spanks her thick ass causing a shrill shriek followed by lustful recovery breaths. The goblin claws his way up onto her back while shes subdued and whips a bar gag into her mouth that is connected by reigns to control her like a mount in battle. Still defiant " + str(target.title) + " bucks wildly sending the goblin soaring back into the crowd with a comical yodel, spitting out the gag she can't help but feel flustered from the experience gaining [color=hotpink]" + str(gained_lust) + " Lust [/color]."
			update_stamina_lust(target,false,true)
	else: 
		if active_seekers.size() >= 1: #elif for ridden then knocked_down
			if action_choice >= 7 and swarm_stats.heat >= 10:
				var skill_check = randi_range(1,55)
				var location_list = ["left breast", "right breast", "left ass cheek", "right ass cheek", "left ankle", "right ankle", "neck"]
				var location_index = randi_range(0,location_list.size() - 1)
				var random_location = location_list[location_index]
				if "Warded" in target.status:
					global.main_text.text += "The Goblin leaps towards " + str(target.title) + " but is blasted back from her crackling ward."
				elif random_location == "left ankle" or random_location == "right ankle":
					global.main_text.text += str(participant.title) + " furiously bites " + str(target.title) + " targeting her " + str(random_location) +  " as he attempts to pull her down to his size."
					if target.durability >= skill_check:
						var damage = randi_range(1,6)
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(1,3)
						target.stamina -= damage
						swarm_stats.heat -= 5
						if swarm_stats.heat <= 0:
							swarm_stats.heat = 0
						global.main_text.text += " Gritting through the pain " + str(target.title) + " shakes her leg harshly sending the goblin bouncing across the ground upon his ejection."
						update_stamina_lust(target,true,false)
					else: 
						var damage = randi_range(2,7)
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(1,6)
						if "Warded" in target.status:
							damage = 0
						target.stamina -= damage
						swarm_stats.heat -= 10
						if swarm_stats.heat <= 0:
							swarm_stats.heat = 0
						knocked_down_seekers.append(target)
						active_seekers.erase(target)
						global.main_text.text += " Unable to contest the sharp pain " + str(target.title) + " falls to her knees as the surrounding goblins start to surround her."
						update_stamina_lust(target,true,false)
				elif random_location == "neck":
					global.main_text.text += str(participant.title) + " goes straight for the neck, leaping up, razor sharp teeth brandished."
					var dodge_roll = randi_range(1,70)
					if target.agility >= dodge_roll or target.strength >= dodge_roll:
						swarm_stats.heat -= 5
						if swarm_stats.heat <= 0:
							swarm_stats.heat = 0
						if target.agility >= target.strength: #add masochist who can't dodge effect? maybe sadist who throws it back
							global.main_text.text += str(target.title) + " Swiftly side steps as the goblin flies past her and bounces roughly on the ground."
						else:
							global.main_text.text += str(target.title) + " catches her assailant by the throat before slamming him onto the ground with causing instantaneous unconsciousness."
					else:
						swarm_stats.heat -= 10
						if swarm_stats.heat <= 0:
							swarm_stats.heat = 0
						var damage = randi_range(6,11)
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(3,8)
						if "Warded" in target.status:
							damage = 0
						target.stamina -= damage
						global.main_text.text += " " + str(target.title) + " is unable to react fast enough as the Goblin fangs sinks violently into her neck causing an eruption of blood. Dealing [color=red]" + str(damage) + " damage [/color]."
						update_stamina_lust(target,true,false)
				else:
					global.main_text.text += str(participant.title) + " jumps and clings onto " + str(target.title) + " cheekily biting into her " + str(random_location)
					var potential_memory = randi_range(1,3)
					var pain_memory = randi_range(1,20)
					var damage = randi_range(1,4)
					if "Sensitive Breasts" in target.fetishes and random_location == "left breast" or random_location == "right breast" and "Sensitive Breasts" in target.fetishes:
						var lust_gain = randi_range(10,20)
						target.lust += lust_gain
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(1,1)
						if "Warded" in target.status:
							damage = 0
						target.stamina -= damage
						global.main_text.text += " because of her sensitive breasts " + str(target.title) + " moans with pleasure even through the pain, gaining " + str(lust_gain) + " lust."
						update_stamina_lust(target,true,true)
					elif "Sensitive Ass" in target.fetishes and random_location == "left ass cheek" or random_location == "right ass cheek" and "Sensitive Ass" in target.fetishes:
						var lust_gain = randi_range(10,20)
						target.lust += lust_gain
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(1,1)
						if "Warded" in target.status:
							damage = 0
						target.stamina -= damage
						global.main_text.text += " because of her sensitive ass " + str(target.title) + " coos with pleasure even through the pain, gaining " + str(lust_gain) + " lust."
						update_stamina_lust(target,true,true)
					else:
						var lust_gain = randi_range(1,6)
						target.lust += lust_gain
						if target.armor == "Fantasy Fullplate":
							damage = randi_range(1,4)
						if "Warded" in target.status:
							damage = 0
						target.stamina -= damage
						global.main_text.text += " a mixture of pain and pleasure stimulates her mind, dealing [color=red]" + str(damage) + "[/color] damage and causing her to gain [color=hotpink]" + str(lust_gain) + "[/color] lust."
						update_stamina_lust(target,true,true)
					if "Chew Toy" not in target.fetishes and potential_memory == 1 and "Bite Mark" not in target.memories:
						target.memories.append("Bite Mark")
						global.main_text.text += "\n\n[color=orchid]As the goblin is flung off " + str(target.title) + " can't help but to feel the not entirely unpleasant sensation of the stinging mark. " + str(target.title) + " gained the memory \"Bite Mark\".[/color]"
					elif "Pain Slut" not in target.fetishes and "Fuck Meat" not in target.fetishes and "Sadistic Stimulator" not in target.fetishes and pain_memory == 1 and "Erotic Injury" not in target.memories: #maybe add not true if sadist
						target.memories.append("Erotic Injury")
						global.main_text.text += "\n\n[color=orchid]" + str(target.title) + " focuses on the pain mixed with the buzzing lust within her heart and she thinks to herself, that wasn't that bad. " + str(target.title) + " gained the memory \"Erotic Injury\".[/color]"
			elif action_choice <= 5:
				var damage = randi_range(3,8)
				if target.armor == "Fantasy Fullplate":
					damage = randi_range(1,6)
				if "Warded" in target.status:
					var roll = randi_range(1,3)
					damage = 0
					if roll == 1:
						global.main_text.text += "The Goblin rears his club attempting to strike " + str(target.title) + " but is blasted back from her crackling ward with a squeal of pain."
					if roll == 2:
						global.main_text.text += "The Goblin rears his club attempting to strike " + str(target.title) + " but is blasted back from her crackling ward with a squeal of pain."
				else:
					target.stamina -= damage
					global.main_text.text += "The " + str(participant.title) + " repeatedly bonk " + str(target.title) + " with their clubs. Dealing [color=red]" + str(damage) + " damage[/color]."
					update_stamina_lust(target,true,false)
			elif action_choice <= 10:
				var dodge_roll = randi_range(1,60)
				var damage = randi_range(4,7)
				if target.armor == "Fantasy Fullplate":
					damage = randi_range(2,5)
				if "Warded" in target.status:
					damage = 0
					global.main_text.text += "The Goblin leaps towards " + str(target.title) + " attempting to pull her to the ground but when the first goblin is sent thrown back violently the goblins decide against grabing her pulsing ward."
				elif target.agility >= dodge_roll or target.strength >= dodge_roll:
					if target.agility <= target.strength: #add masochist who can't dodge effect? maybe sadist who throws it back
						global.main_text.text += "With a triumphant Goblin battle cry the goblins attempt to knock down " + str(target.title) + ". down with force but is instead thrown away easily."
					else:
						global.main_text.text += "With a triumphant Goblin battle cry the goblins attempt to knock down " + str(target.title) + ". Unable to grab her because of her swiftness she escapes their range as they follow her screaming with their weapons raised."
				else:
					target.stamina -= damage
					global.main_text.text += "the goblins surround " + str(target.title) + " and toppel her over. Dealing [color=red]" + str(damage) + " damage[/color] and knocking her prone." #just for testing will be a normal attacks otherwise
					update_stamina_lust(target,true,false)
					knocked_down_seekers.append(target)
					active_seekers.erase(target)
		elif knocked_down_seekers.size() >= 1: #elif for ridden then knocked_down
			var index = randi_range(0,knocked_down_seekers.size() - 1)
			target = knocked_down_seekers[index]
			if target.lust >= target.max_lust * 0.5:
				var sex_type = ["handjob", "blowjob", "vaginal", "anal", "spitroast", "both holes", "double anal",]
				var sex_type_choice = sex_type[randi_range(0,sex_type.size() - 1)]
				var tagteam_type = ["handjob", "vaginal", "anal", "spitroast", "evreything", "both holes", "double anal", "double vaginal"]
				var tagteam = randi_range(1,3)
				var lust = randi_range(3,7)
				if target.fucking_intensity == 0:
					target.lust += lust
					target.fucking_intensity = 1
					sex_type = ["handjob", "blowjob", "groping", "degradation"]
					sex_type_choice = sex_type[randi_range(0,sex_type.size() - 1)]
					if sex_type_choice == "handjob":
						global.main_text.text += "\nThe goblins surround " + str(target.title) + " and perform foreplay.\nReady for some fun, the goblins push their girthy meat towards her while snickering. " + str(target.title) + " grasps their rods milling them with her hands making them feel loved before moving to the next set of cocks. Her gentle hand dances across their meat rhythmically causing a rising lust between the goblins."
					if sex_type_choice == "blowjob":
						global.main_text.text += "\nThe goblins surround " + str(target.title) + ", she kisses their tips each in turn before oppening wide and clamping down, her head starts bobbing and spit starts flying as she pleasures and lubricates a cock before moving to the next delictably girthy shaft."
					if sex_type_choice == "degradation":
						global.main_text.text += "\nThe goblins surround " + str(target.title) + " and perform foreplay.\n The goblins make sure she knows her place, degrading her, spitting on her, spanking and caressing her robust ass while yanking her hair, despite the bullying " + str(target.title) + " can't help but to get super wet from all the attention."
					if sex_type_choice == "groping":
						var random_text = randi_range(1,5)
						if random_text == 1:
							global.main_text.text += "\nThe goblins surround " + str(target.title) + " they grope he ass and " + str(target.breast_type) + " lecherously causing moans to escape her soft lips, tempted, the goblins groping go from touching to fingering, their digits erotically prying their way into her wet hot holes."
						if random_text == 2:
							global.main_text.text += "\n" + str(target.title) + " lay on the muddy forest floor, her sweaty body shining in the humid heat. Her large breasts rose and fell with each breath, nipples stiff and inviting.\n\nRough green hands touched Elica's hips, fingers gripping her flesh as they moved up to caress her chest. The goblin squeezed her nipples, eliciting a moan from " + str(target.title) + " as she arched her back.\n\n \"Touch me more, you filthy creatures!\" " + str(target.title) + " gasped, squirming lustfully under the goblins savage digits. \"Pinch my breasts harder! Make them yours!\""
					if target.lust >= target.max_lust:
						target.lust = target.max_lust * 0.5
						target.stamina -= randi_range(10,15)
						global.main_text.text += "\n\n" + str(target.title) + " orgasms! Squirting messily."
						global.main_text.text += "\n" + str(target.title) + ":\nNew Stamina: " + str(target.stamina) + "/" + str(target.max_stamina) + "\nNew Lust: " + str(target.lust) + "/" + str(target.max_lust)
					else:
						global.main_text.text += "\n\n" + str(target.title) + "\nNew lust: " + str(target.lust) + "/" + str(target.max_lust)
				elif target.fucking_intensity == 1:
					var ejaculate = randi_range(50,80)
					var damage = randi_range(5,15)
					swarm_stats.hp -= damage
					lust += randi_range(1,3)
					target.lust += lust
					target.fucking_intensity = 2
					sex_type = ["vaginal", "blowjob", ] #"titjob", "anal"
					sex_type_choice = sex_type[randi_range(0,sex_type.size() - 1)]
					if sex_type_choice == "vaginal":
						global.main_text.text += "\nThe goblins decide that they want to impregnate " + str(target.title) + " they shift her easily pliable legs open and the first in line lines up his forbodingingly gruesome shaft, as he thrusts carelessly it slides off her wet needy slit. her meaty hole cries in desire as she spasms and squirts a little onto the phallice even from the gentle pleasure. As the goblin tries again the shaft soars with little resistance right into the wombs lips, the pressure doesn't take long with a couple quick thrust's the goblin explodes " + str(ejaculate) + "ml of goblin sperm into her tight little pussy " + str(target.title) + " moans in satisfaction as hot jizz fills her up and roils out of her needy hole. Thats when the next goblin in line enters, fucking her without rest, obscene plap noises and lustful moaning emanates loudly from the orgy. Dealing [color=red]" + str(damage) + " [/color] damage ."
					if sex_type_choice == "blowjob":
						global.main_text.text += "\nA particularly eager goblin grabs " + str(target.title) + " by her hair and pulls her skilled sloppy mouth onto his swollen shaft. She instantly gags as the long girthy phallice prods at the back of her throat, the goblin loves the sensation and begins to skull fuck her throat pussy rhymically. With every gag and wet choking noise " + str(target.title) + " gets more and more into her role as convinient fuck toy and starts forcing herself to match his harsh thrusts. she feels his cock twitch in her gullet and picks up the pace even more causing a messily expulsion of " + str(ejaculate) + " ml of cum into her throat pussy. She feels incomplete as the limp cock exits her mouth but luckily for her the other goblins are emboldened by their brothers erotic bravery and start crowding around. " + str(target.title) + " can't help but to lick her lips to get ready for the next serving of piping hot jizz. Dealing [color=red]" + str(damage) + "[/color] damage to the goblins."
					if target.lust >= target.max_lust:
						target.lust = target.max_lust * 0.5
						target.stamina -= randi_range(10,15)
						global.main_text.text += "\n\n" + str(target.title) + " orgasms! Squirting messily."
						global.main_text.text += "\n" + str(target.title) + ":\nNew Stamina: " + str(target.stamina) + "/" + str(target.max_stamina) + "\nNew Lust: " + str(target.lust) + "/" + str(target.max_lust)
					else:
						global.main_text.text += "\n\n" + str(target.title) + "\nNew lust: " + str(target.lust) + "/" + str(target.max_lust)
				elif target.fucking_intensity == 2:
					var ejaculate = randi_range(100,160)
					var damage = randi_range(10,20)
					swarm_stats.hp -= damage
					lust += randi_range(2,6)
					target.lust += lust
					target.fucking_intensity = 3
					sex_type = ["vaginal and anal", ] #spitroast
					sex_type_choice = sex_type[randi_range(0,sex_type.size() - 1)]
					if sex_type_choice == "vaginal and anal":
						global.main_text.text += "\nThe goblins heated with lust focus in on " + str(target.title) + " and her needy willing ass and pussy. A goblin slides underneath shoving his massive shaft into her pussy while another mounts her fat ass and presses his obscenely thick member pass the rim. With libidinous thrusts and salacious howls the goblins expand and fuck their respective hungry holes until they all cum in unison, spraying " + str(ejaculate) + "ml of goblin sperm into her used holes as the goblins disperse two more take their place, replacing her blissfully vulgar afterglow with two hard pistoning cocks in her gaping ass and creampied pussy. Dealing [color=red]" + str(damage) + "[/color] damage to the goblins."
					if target.lust >= target.max_lust:
						target.lust = target.max_lust * 0.5
						target.stamina -= randi_range(2,5)
						global.main_text.text += "\n\n" + str(target.title) + " orgasms! ejecting the cocks from her sensitive holes."
						update_stamina_lust(target,true,true)
					else:
						update_stamina_lust(target,false,true)
				elif target.fucking_intensity == 3:
					var ejaculate = randi_range(300,540)
					var damage = randi_range(20,40)
					swarm_stats.hp -= damage
					lust += randi_range(4,12)
					target.lust += lust
					target.fucking_intensity = 2
					sex_type = ["orgy", ] #spitroast
					sex_type_choice = sex_type[randi_range(0,sex_type.size() - 1)]
					if sex_type_choice == "orgy":
						global.main_text.text += "\nThe goblins fuck " + str(target.title) + " in all of her holes, spraying " + str(ejaculate) + "ml of steaming hot goblin jizz all in and over her. Dealing [color=red]" + str(damage) + " damage to the goblins [/color]."
					if target.lust >= target.max_lust:
						target.lust = target.max_lust * 0.5
						target.stamina -= randi_range(10,15)
						global.main_text.text += "\n\n" + str(target.title) + " orgasms! Squirting messily."
						update_stamina_lust(target,true,true)
					else:
						update_stamina_lust(target,false,true)
			else:
				var lust = randi_range(2,5)
				target.lust += lust
				if target.lust > target.max_lust:
					target.lust = target.max_lust
				global.main_text.text += "the goblins lecherously jack off to " + str(target.title) + " just watching their manhoods get pumped makes her burn with temptation. Gaining [color=hotpink]" + str(lust) + "[/color] lust."
				update_stamina_lust(target,false,true)
	if target.stamina <= 0:
		global.main_text.text += "\n\n" + str(target.title) + " has ran out of stamina and is unable to fight anymore. passing out." 
		if target in active_seekers:
			knocked_down_seekers.append(target)
			active_seekers.erase(target)
	global.main_text.text += "\n------------------------\n"
	update_ui()
	current_turn += 1
	process_turns()
	

func player_turn(seeker):
	var loss_by_stamina_counter = 0 #used to count how many seekers have 0 stamina. if all then loss
	global.clear_seeker_buttons()
	if seeker.stamina <= 0:
		if seeker in active_seekers:
			knocked_down_seekers.append(seeker)
			active_seekers.erase(seeker)
		for i in all_seekers:
			if i.stamina <= 0:
				loss_by_stamina_counter += 1
			if loss_by_stamina_counter >= all_seekers.size():
				global.main_text.text += "\n" + str(seeker.title) + " doesn't have enough stamina to act.\n\n"
				global.main_text.text += "\n------------------------\n"
				loss()
				break
		global.main_text.text += "\n" + str(seeker.title) + " doesn't have enough stamina to act.\n\n"
		global.main_text.text += "\n------------------------\n"
		current_turn += 1
		update_ui()
		process_turns()
	else:
		if seeker.lust >= seeker.max_lust * 0.5:
			for desire in seeker.desires:
				var desire_button = Button.new()
				desire_button.text = desire.title  # 'ability' is a string representing the skill name
				global.button_container.add_child(desire_button)
				desire_button.pressed.connect(Callable(self, "_perform_desire").bind(desire, seeker))
				global.left_buttons.append(desire_button)
		#if sex in status do that instead of regular turn
		else:
			for ability in seeker.skill_objects:
				var skill_button = Button.new()
				skill_button.text = ability.title  # 'ability' is a string representing the skill name
				global.button_container.add_child(skill_button)
				skill_button.pressed.connect(Callable(self, "_perform_skill").bind(ability, seeker))
				global.left_buttons.append(skill_button)
		var next_turn = Button.new()
		next_turn.text = "Do Nothing"
		global.button_container.add_child(next_turn)
		next_turn.pressed.connect(Callable(self, "skip_turn").bind(seeker))
		global.left_buttons.append(next_turn)
		var skill_info_button = Button.new() #change main text to a description of all current skills by doing for and describing them
		skill_info_button.text = "Skill Info"
		global.button_container.add_child(skill_info_button)
		skill_info_button.pressed.connect(Callable(self, "skill_info").bind(seeker,skill_info_button))
		global.left_buttons.append(skill_info_button)
		var inspect_button = Button.new() #change main text to a description of all current skills by doing for and describing them
		inspect_button.text = "Inspect"
		global.button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "inspect_choice").bind(seeker,inspect_button))
		global.left_buttons.append(inspect_button)

func _perform_skill(ability, seeker):
	var current_text = global.main_text.text
	global.main_text.text += "\n" + str(seeker.title) +  " uses " + str(ability.title)
	if ability.target_enemy == true:
		global.clear_seeker_buttons()
		if global.right_buttons.size() >= 2:
			global.clear_enemy_buttons()
			for target in active_enemies:
				var seeker_target = Button.new()
				seeker_target.text = target.title
				global.right_button_container.add_child(seeker_target)
				seeker_target.pressed.connect(Callable(self, "skill_logic").bind(ability,seeker,target))
				global.right_buttons.append(seeker_target)
		else:
			skill_logic(ability,seeker,swarm_stats) #this is right, swarm stats is the target if no other are available
	elif ability.target_ally == true:
		global.clear_seeker_buttons()
		if ability.target_self == false:
			active_seekers.erase(seeker)
		for target in active_seekers:
			var seeker_target = Button.new()
			seeker_target.text = target.title
			global.button_container.add_child(seeker_target)
			seeker_target.pressed.connect(Callable(self, "skill_logic").bind(ability,seeker,target))
			global.left_buttons.append(seeker_target)
		var back_button = Button.new()
		back_button.text = "Back"
		global.button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "back_to_skill_select").bind(seeker,current_text,back_button))
		global.left_buttons.append(back_button)
		if ability.target_self == false:
			active_seekers.append(seeker)
	elif ability.target_self == true:
		global.clear_seeker_buttons()
		skill_logic(ability, seeker, seeker)
	did_crit = false

func _perform_desire(ability, seeker):
	var current_text = global.main_text.text
	global.main_text.text += "\n" + str(seeker.title) +  " uses " + str(ability.title)
	if ability.target_enemy == true:
		global.clear_seeker_buttons()
		if global.right_buttons.size() >= 2:
			global.clear_enemy_buttons()
			for target in active_enemies:
				var seeker_target = Button.new()
				seeker_target.text = target.title
				global.right_button_container.add_child(seeker_target)
				seeker_target.pressed.connect(Callable(self, "desire_logic").bind(ability,seeker,target))
				global.right_buttons.append(seeker_target)
		else:
			desire_logic(ability,seeker,swarm_stats) #this is right, swarm stats is the target if no other are available
	elif ability.target_ally == true:
		global.clear_seeker_buttons()
		if ability.target_self == false:
			active_seekers.erase(seeker)
		for target in active_seekers:
			var seeker_target = Button.new()
			seeker_target.text = target.title
			global.button_container.add_child(seeker_target)
			seeker_target.pressed.connect(Callable(self, "desire_logic").bind(ability,seeker,target))
			global.left_buttons.append(seeker_target)
		for target in knocked_down_seekers:
			var seeker_target = Button.new()
			seeker_target.text = target.title
			global.button_container.add_child(seeker_target)
			seeker_target.pressed.connect(Callable(self, "desire_logic").bind(ability,seeker,target))
			global.left_buttons.append(seeker_target)
		var back_button = Button.new()
		back_button.text = "Back"
		global.button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "back_to_skill_select").bind(seeker,current_text,back_button))
		global.left_buttons.append(back_button)
		if ability.target_self == false:
			active_seekers.append(seeker)
	elif ability.target_self == true:
		global.clear_seeker_buttons()
		desire_logic(ability, seeker, seeker)
	did_crit = false

func check_for_crit(ability):
	var d100 = randi_range(1,100)
	if d100 <= ability.crit_range:
		did_crit = true
		
func desire_logic(ability, seeker, target):
	var damage_done = 0
	#maybe move damage and effects here so that its more modular
	check_for_crit(ability)
	swarm_stats.heat += randi_range(1,3) #if high heat they do scarier actions
	if swarm_stats.heat >= 20:
		swarm_stats.heat = 20
	match ability.title:
		"Submit":
			knocked_down_seekers.append(seeker)
			active_seekers.erase(seeker)
			seeker.stamina = seeker.max_stamina
			global.main_text.text += "\n------------------------\n" + str(seeker.title) + " gives in to an odd temptation to give up. She drops to her knees and begs the goblins for mercy! He heart beats faster as the goblin surround her making snide and crude remarks about her body.\n" + str(seeker.title) + ": I won't fight back anymore, I'll do whatever you want." 
			update_stamina_lust(seeker,true,false)
		"Fantasize":
			var heal = randi_range(5,10)
			seeker.stamina += heal
			if seeker.stamina >= seeker.max_stamina:
				seeker.stamina = seeker.max_stamina
			var lust = randi_range(5,10)
			seeker.stamina += lust
			global.main_text.text += "\n------------------------\n" + str(seeker.title) + " mind drifts to erotic fantasy, the savage goblins with aproach her with carnal lust and tear away her clothes revealing her supple frame. then they would tease her body, rubbing up and down her limbs, squeezing and carressing her most erotic parts before finally parting her trembling legs and penetrating her as she cries out in overwhelming bliss. She feels her desire build as she's unable to stop her thighs from grinding together.\n" + str(seeker.title) + ": O-oh my god... ah, i'm so wet.\nrecovering[color=red] " + str(heal) + "[/color] stamina and gaining[color=hotpink] " + str(lust) + "[/color] lust."
			update_stamina_lust(seeker,true,true)
		"Experiment":
			var damage = randi_range(5,10)
			var heal = randi_range(5,10)
			var lust = randi_range(5,10)
			var effect_roll = randi_range(1,6)
			if effect_roll == 1 or effect_roll == 2:
				seeker.stamina += heal
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " lets her arousal take control for a moment, she gropes her breasts, carressing her supple body down to her wet pussy, she rubs it delcatily unpreturbed that she is being watched, she just focuses on herself and how light shes feeling.\n" + str(seeker.title) + ": Wow. this is bliss.\nrecovering[color=green] " + str(heal) + "[/color] stamina and gains[color=hotpink] " + str(lust) + "[/color] lust."
				update_stamina_lust(seeker,true,true)
			if effect_roll == 3 or effect_roll == 4:
				seeker.stamina -= damage * 0.5
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " can no longer ignore her burning desire, she runs her fingers over her " + str(seeker.breast_type) + " breasts, not enough she pinches her nipples and pulls, the gobblins that gawk only make her want to pull harder to give them a lewder show.\n" + str(seeker.title) + ": O-ohohoh this... this is how I like it.\ndealing herself[color=red] " + str(damage * 0.5) + " damage[/color] and gains[color=hotpink] " + str(lust) + "[/color] lust."
				update_stamina_lust(seeker,true,true)
			if effect_roll == 5 or effect_roll == 6:
				swarm_stats.hp -= damage
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " drops to her knees to get a closer look at one of the goblin's ample tool, she grasps it with curiosity, bending, pulling and twisting in all sorts ways with fervent curiosity.\n" + str(seeker.title) + ": It throbs whenever I grab it like this.\ndealing the swarm[color=red] " + str(damage) + " damage[/color] and gains[color=hotpink] " + str(lust) + "[/color] lust."
				update_stamina_lust(seeker,false,true)
			global.main_text.text += "\n------------------------\n"
		"Attract Attention":
			var heal = randi_range(15,25)
			var lust = randi_range(5,10)
			seeker.threat = 80
			seeker.cooldown_2.append("Taunt")
			seeker.lust += lust
			seeker.stamina += heal
			global.main_text.text += "\n------------------------\n" + str(seeker.title) + " takes a deep breath in before challenging the goblins to come get her, taking a confident pose that emphasizes her curves. The goblins stare at their prey with burning passion their focused gaze causes her to shiver with anticipation.\n" + str(seeker.title) + ": That's it you green little freaks, see if you can beat me.\nrecovering[color=green] " + str(heal) + "[/color] stamina and gaining[color=hotpink] " + str(lust) + "[/color] lust."
			update_stamina_lust(seeker,true,true)
		"Dominate":
			var damage = randi_range(15,25)
			var lust = randi_range(5,10)
			if target in knocked_down_seekers:
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " used her boot to grind " + str(target.title) + " into the dirt face first while the goblins assualt and degrade her in their own way, when she gets bored of that she pulls her foot away just to spit onto her and to watch her pathetic face with sadistic arousal. " + str(seeker.title) + " Haha now lick my feet slut.\n" + str(target.title) + " Y-yes mistress.\nthe goblins get into a frenzy as they lose " + str(damage) + " and " + str(seeker.title) + " gains " + str(lust) + " lust from her sadistic desires."
				update_stamina_lust(seeker,false,true)
			if target in active_seekers:
				#give pp and fetishes
				knocked_down_seekers.append(target)
				active_seekers.erase(target)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " kicks " + str(target.title) + " to the ground, landing face first with a thud, she goes to complain but is instead met with a harsh spank which instantly captures the attention of her and the goblins. " + str(seeker.title) + " Hush now, be a good pet and wiggle your slutty ass for them.\n" + str(target.title) + " F-fine! Please piledrive my needy holes into the dirt and fill me with your hot spunk."
				update_stamina_lust(seeker,true,true)
	current_turn += 1
	if ability.cooldown == 2:
		seeker.cooldown_3.append(ability)
		seeker.skill_objects.erase(ability)
	if ability.cooldown == 1:
		seeker.cooldown_2.append(ability)
		seeker.skill_objects.erase(ability)
	if ability.one_use == true:
		seeker.cooldown_battle.append(ability)
		seeker.skill_objects.erase(ability)
	update_ui()
	process_turns()

func skill_logic(ability, seeker, target):
	var damage_done = 0
	#maybe move damage and effects here so that its more modular
	check_for_crit(ability)
	swarm_stats.heat += randi_range(1,3) #if high heat they do scarier actions
	if swarm_stats.heat >= 20:
		swarm_stats.heat = 20
	match ability.title:
		"Clang!":
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.strength* 0.5 + seeker.durability * 0.2 + ability.base_damage)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " heaves her ginormous weapon, and targets a particular goblin. It watches in horror as the shadow of the grand weapon encroches upon him and with a resounding splat, that Goblin is done. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			else:
				damage_done = int(randi_range(1,5) + seeker.strength* 0.5 + seeker.durability * 0.2 + ability.base_damage * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " heaves her ginormous weapon, and targets a particular goblin. It watches in horror as the shadow of the grand weapon encroches upon him and with a resounding splat, that Goblin is done. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			swarm_stats.hp -= damage_done
		"Multi Slash":
			if "Opportunity" in seeker.status:
				did_crit = true
				seeker.status.erase("Opportunity")
			total_damage = 0
			var critical_hits = 0
			for i in ability.multihit:
				if did_crit == false:
					damage_done = int(randi_range(1,5) + seeker.strength * 0.1 + seeker.agility * 0.2 + ability.base_damage)
				else:
					damage_done = int(randi_range(1,5) + seeker.strength * 0.1 + seeker.agility * 0.2 + ability.base_damage * ability.crit_value)
					critical_hits += 1
				swarm_stats.hp -= damage_done
				total_damage += damage_done
			global.main_text.text += "\n------------------------\n" + str(seeker.title) + " flies into the Goblin swarm swiftly slicing down their ranks before diving free from any counter attacks. Dealing [color=crimson]" + str(total_damage) + " [/color]total damage."
			if critical_hits >= 1:
				global.main_text.text += "\n\nThe attacks crit " + str(critical_hits) + " times."
			total_damage = 0
		"Vital Cut":
			if "Opportunity" in seeker.status:
				did_crit = true
				seeker.status.erase("Opportunity")
			if did_crit == false:
				damage_done = int(randi_range(1,5) - seeker.threat + ability.base_damage * 0.8)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With precision strikes at a goblins vitals slaying them instantly. Dealing [color=crimson]" + str(damage_done) + " [/color]damage to the horde"
			else:
				damage_done = int(randi_range(1,5) - seeker.threat + ability.base_damage * 0.8 * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With precision strikes at a goblins vitals slaying them instantly. Criting and dealing [color=crimson]" + str(damage_done) + " [/color]damage to the horde"
			swarm_stats.hp -= damage_done
		"Distracting Strike":
			if "Opportunity" in seeker.status:
				did_crit = true
				seeker.status.erase("Opportunity")
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.3 + seeker.strength * 0.2 + ability.base_damage * 0.8)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With an intentionally violent slash a fountain of blood erupts from a slain goblin coating his brothers in crimson. Dealing [color=crimson]" + str(damage_done) + " [/color]damage and distracting the group."
			else:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.3 + seeker.strength * 0.2 + ability.base_damage * 0.8 * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " With an intentionally violent slash a fountain of blood erupts from a slain goblin coating his brothers in crimson. Criting and dealing [color=crimson]" + str(damage_done) + " [/color]damage and distracting the group."
			swarm_stats.hp -= damage_done
			seeker.status.append("Opportunity") #
		"Singular Shot":
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.5 + seeker.will * 0.5 + ability.base_damage * 0.8)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " loads a heavy bolt and aims for the central mass of the Goblins penetrating and skewering multiple enemies from the violent impact. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			else:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.5 + seeker.will * 0.5 + ability.base_damage * 0.8 * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " loads a heavy bolt and aims for the central mass of the Goblins penetrating and skewering multiple enemies from the violent impact. Criting and dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			swarm_stats.hp -= damage_done
		"Napalm Bolt":
			swarm_stats.status.append("Burn")
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.2 + seeker.will * 0.3 + ability.base_damage * 1.8)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Swiftly modifies her ammo as the goblins lecherously aproaches her, kicking one back after her preperations she dives back while shooting the monster causing a detonation of dire heat and frightining fire, the goblins caught in the blast scream and run about flesh melting away. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			else:
				damage_done = int(randi_range(1,5) + seeker.agility * 0.2 + seeker.will * 0.3 + ability.base_damage * 1.8 * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Swiftly modifies her ammo as the goblins lecherously aproaches her, kicking one back after her preperations she dives back while shooting the monster causing a detonation of dire heat and frightining fire, the goblins caught in the blast scream and run about flesh melting away. Criting and dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			swarm_stats.hp -= damage_done
		"Inspire":
			swarm_stats.heat -= randi_range(3,6)
			if swarm_stats.heat <= 0:
				swarm_stats.heat = 0
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.will * 0.6 + ability.base_damage * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " encourages " + str(target.title) + " to keep pushing forward. Some of the Goblins snicker at her optimism. Healing [color=green]" + str(damage_done) + " [/color]stamina."
			else:
				damage_done = int(randi_range(1,5) + seeker.will * 0.6 + ability.base_damage * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " encourages " + str(target.title) + " to keep pushing forward. Some of the Goblins snicker at her optimism. Criting and healing [color=green]" + str(damage_done) + " [/color]stamina."
			target.stamina += damage_done
			if seeker.stamina >= seeker.max_stamina:
				seeker.stamina = seeker.max_stamina
		"Vault":
			var seeker_threat_change = seeker.threat #- the value off this, then add back 10 after the buff runs out
			swarm_stats.heat -= randi_range(3,6)
			if swarm_stats.heat <= 0:
				swarm_stats.heat = 0
			seeker.status.append("Moderate agility buff")
			seeker.agility += 10
			seeker.status.append("Backline")
			seeker.threat = 10
			for i in seeker.skills:
				match i:
					"Lightfoot":
						seeker.threat -= 3
					"Colossal Weapon":
						seeker.threat += 6
					_:
						pass
		"Struggle":
			if did_crit == false:
				damage_done = int(randi_range(1,5) + ability.base_damage)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " punches and kicks to keep the Goblins away doing very little. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			else:
				damage_done = int(randi_range(1,5) + ability.base_damage * ability.crit_value)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " punches and kicks to keep the Goblins away doing very little. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			swarm_stats.hp -= damage_done
		"Daemonic Advance":
			print("agaga")
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.intelligence * 0.3 + seeker.lust * 0.5 + ability.base_damage * 1.2)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " summons a swarm of large undulating tentacles to cause chaos, they grasp and squeeze, flinging goblins like toys. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			else:
				damage_done = int(randi_range(1,5) + seeker.intelligence * 0.3 + seeker.lust * 0.5 + ability.base_damage * ability.crit_value * 1.2)
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " summons a swarm of large undulating tentacles to cause chaos, they grasp and squeeze, flinging goblins like toys. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
			swarm_stats.hp -= damage_done
		"Echo of Ruin":
			var lust_gain = randi_range(5,10)
			seeker.lust += lust_gain
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.intelligence * 0.2 + seeker.lust * 0.7 + ability.base_damage * 1.4 )
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Conjures chaotic crackling energy from her tome, it coalesces before cascading forth in a brilliant explosion. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
				if knocked_down_seekers.size() >= 1:
					global.main_text.text += " The blast is so reckless it's residual energy affects those that can't escape the blast zone."
					for victim in knocked_down_seekers:
						var damage = damage_done * 0.5
						victim.stamina -= damage
						victim.lust += lust_gain
						if seeker.lust >= seeker.max_lust:
							seeker.lust = seeker.max_lust
						# check for stamina dropping to 0
						global.main_text.text += "\n" + str(victim.title) + "\nNew Stamina: " + str(victim.stamina) + "/" + str(victim.max_stamina) + "\nNew Lust: " + str(victim.lust) + "/" + str(victim.max_lust)
			else:
				damage_done = int((randi_range(1,5) + seeker.intelligence * 0.2 + seeker.lust * 0.7 + ability.base_damage + ability.crit_value) * 1.2  )
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " Conjures chaotic crackling energy from her tome, it coalesces before cascading forth in a brilliant explosion. Dealing [color=crimson]" + str(damage_done) + " [/color]damage."
				if knocked_down_seekers.size() >= 1:
					global.main_text.text += " The blast is so reckless it's residual energy affects those that can't escape the blast zone."
					for victim in knocked_down_seekers:
						var damage = damage_done * 0.5
						victim.stamina -= damage
						# check for stamina dropping to 0
						update_stamina_lust(victim,true,true)
			swarm_stats.hp -= damage_done
			update_stamina_lust(seeker,false,true)
		"Warding Words":
			target.cooldown_2.append("Warded")
			target.status.append("Warded")
			swarm_stats.heat -= randi_range(3,6)
			if swarm_stats.heat <= 0:
				swarm_stats.heat = 0
			if did_crit == false:
				damage_done = int(randi_range(1,5) + seeker.intelligence * 0.3 + seeker.lust * 0.6 + ability.base_damage)
				seeker.lust += damage_done
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " flips open her tome of tremendous power and chants an entry.  " + str(target.title) + " is washed in a barrier of buzzing pink energy. Protecting her from further harm. However the lustful backlash wracks " + str(seeker.title) + " with torturous desire. gaining [color=hotpink]" + str(damage_done) + " [/color]lust."
			else:
				damage_done = int(randi_range(1,5) + seeker.intelligence * 0.3 + seeker.lust * 0.6 + ability.base_damage * ability.crit_value) #currently can't crit
				seeker.lust += damage_done
				global.main_text.text += "\n------------------------\n" + str(seeker.title) + " flips open her tome of tremendous power and chants an entry.  " + str(target.title) + " is washed in a barrier of buzzing pink energy. Protecting her from further harm. However the lustful backlash wracks " + str(seeker.title) + " with torturous desire. gaining [color=hotpink]" + str(damage_done) + " [/color]lust."
			if seeker.stamina >= seeker.max_stamina:
				seeker.stamina = seeker.max_stamina
			global.main_text.text += "\n\n" + str(seeker.title) + "\nNew lust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	global.main_text.text += "\n------------------------\n"
	current_turn += 1
	if ability.cooldown == 2:
		seeker.cooldown_3.append(ability)
		seeker.skill_objects.erase(ability)
	if ability.cooldown == 1:
		seeker.cooldown_2.append(ability)
		seeker.skill_objects.erase(ability)
	if ability.one_use == true:
		seeker.cooldown_battle.append(ability)
		seeker.skill_objects.erase(ability)
	var main_text_scroll = global.main_text.get_v_scroll_bar()
	main_text_scroll.value = main_text_scroll.max_value
	update_ui()
	process_turns()


func end_round():
	var defeat_by_stamina_check = 0
	for seeker in all_seekers:
		cooldowns(seeker)
		if seeker.weapon == "Bound Tome":
			var random_roll = randi_range(1,2)
			if random_roll == 1:
				seeker.stamina += 5
				if seeker.stamina >= seeker.max_stamina:
					seeker.stamina = seeker.max_stamina
				global.main_text.text += str(seeker.title) + " regains 5 stamina from her tome's residual energy.\n" + str(seeker.title) + ":\n New Stamina: " + str(seeker.stamina) + "/" + str(seeker.max_stamina) + "\n"
			else:
				seeker.lust += 5
				if seeker.lust >= seeker.max_lust:
					update_stamina_lust(seeker,false,true)
				global.main_text.text += str(seeker.title) + " notices her tome whispers in a cacophony of unknown words, suddenly she feels her desire florish and her body to heat up. Gaining 5 lust.\n" + str(seeker.title) + ":\n New Lust: " + str(seeker.lust) + "/" + str(seeker.max_lust) + "\n"
			global.main_text.text += "\n------------------------\n"
	if knocked_down_seekers.size() == 0:
		swarm_stats.heat += randi_range(3,8)
		if swarm_stats.heat >= 20:
			swarm_stats.heat = 20
	for status in swarm_stats.status:
		if status == "Burn":
			swarm_stats.hp -= randi_range(10,20)
			var status_keep = randi_range(0,1)
			if status_keep <= 0:
				swarm_stats.status.erase("Burn")
				global.main_text.text += " The Goblins that were on fire have either died or put it out.\n\n" 
	update_ui()
	for seeker in all_seekers:
		if seeker.stamina <= 0:
			defeat_by_stamina_check += 1
	if defeat_by_stamina_check >= all_seekers.size():
		loss()
	else:
		var next_turn = Button.new()
		next_turn.text = "End Round"
		global.button_container.add_child(next_turn)
		next_turn.pressed.connect(Callable(self, "roll_initiative"))
		global.left_buttons.append(next_turn)

func cooldowns(seeker):
	for skill in seeker.cooldown_1:
		if skill is String:
			if skill == "Warded":
				global.main_text.text += "\n" + str(seeker.title) + " is no longer warded. "
				seeker.cooldown_1.erase(skill)
				seeker.status.erase(skill)
			if skill == "Taunt":
				global.main_text.text += "\n" + str(seeker.title) + " is no longer taunting. "
				global._unequip_item_skills(seeker)
				global.apply_equipment(seeker)
				seeker.cooldown_1.erase(skill)
				seeker.status.erase(skill)
		else:
			seeker.skill_objects.append(skill)
			seeker.cooldown_1.erase(skill)
	for skill in seeker.cooldown_2:
		if skill is String:
			if skill == "Warded":
				seeker.cooldown_1.append(skill)
				seeker.cooldown_2.erase(skill)
			if skill == "Taunt":
				seeker.cooldown_1.append(skill)
				seeker.cooldown_2.erase(skill)
		else:
			seeker.cooldown_1.append(skill)
			seeker.cooldown_2.erase(skill)
	for skill in seeker.cooldown_3:
		if skill is String:
			if skill == "Warded":
				seeker.cooldown_2.append(skill)
				seeker.cooldown_3.erase(skill)
			if skill == "Taunt":
				seeker.cooldown_1.append(skill)
				seeker.cooldown_2.erase(skill)
		else:
			seeker.cooldown_2.append(skill)
			seeker.cooldown_3.erase(skill)
		

func skill_info(seeker, skill_info_button):
	global.clear_seeker_buttons()
	var current_text = global.main_text.text
	global.button_container.remove_child(skill_info_button)
	for ability in seeker.skill_objects:
		var skill_button = Button.new()
		skill_button.text = ability.title  # 'ability' is a string representing the skill name
		global.button_container.add_child(skill_button)
		skill_button.pressed.connect(Callable(self, "_perform_skill").bind(ability, seeker))
		global.left_buttons.append(skill_button)
	var back_button = Button.new()
	back_button.text = "Back"
	global.button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "back_to_skill_select").bind(seeker,current_text,back_button))
	global.left_buttons.append(back_button)
	global.main_text.text = "------------------------\n"
	for skill in seeker.skills:
		match skill:
			"Multi Slash":
				global.main_text.text += "Multi Slash:\n Strike twice dealing damage with agility and strength."
				global.main_text.text += "\n------------------------\n"
			"Lightfoot":
				global.main_text.text += "Lightfoot:\n Passive: Lowers threat by 3 and raises agility by 5."
				global.main_text.text += "\n------------------------\n"
			"Vital Cut":
				global.main_text.text += "Vital Cut:\n Does high flat damage that is subtracted by your current Threat."
				global.main_text.text += "\n------------------------\n"
			"Distracting Strike":
				global.main_text.text += "Distracting Strike:\n Low damage attack that creats an Opportunity for yourself.\n Your next Twin Dagger attack is a guranteed crit."
				global.main_text.text += "\n------------------------\n"
			"Singular Shot":
				global.main_text.text += "Singular Shot:\n A powerful bolt is fired using agility. \n Though powerful it does take a moment to reload."
				global.main_text.text += "\n------------------------\n"
			"Vault":
				global.main_text.text += "Vault:\n Take aggro off yourself while increasing your agility."
				global.main_text.text += "\n------------------------\n"
			"Focus Impact": #maybe change to focus something to describe the will adding skill sounds like it adds strength
				global.main_text.text += "Focus Impact:\n Passive: Add the seeker's will to all crossbow weapon skills."
				global.main_text.text += "\n------------------------\n"
			"Napalm Bolt":
				global.main_text.text += "Napalm Bolt:\n Rain down an area merciless fire, takes a moment to load.\n Be careful of allies."
				global.main_text.text += "\n------------------------\n"
			"Inspire":
				global.main_text.text += "Inspire:\n Heal another seeker's stamina with your will. You will have to focus on battle though, so the\n skill has a 1 turn cooldown."
				global.main_text.text += "\n------------------------\n"
			"Whispers of Venus":
				global.main_text.text += "Whispers of Venus:\n All Bound Tome skills scale off your lust. and at the end of the round the tome will leak\n enegy either giving you stamina or lust."
				global.main_text.text += "\n------------------------\n"
			"Warding Words":
				global.main_text.text += "Warding Words:\n protect an ally from taking any damage for 1 round, releasing such potent protection comes\n with a lewd cost. skill can only be used once per combat."
				global.main_text.text += "\n------------------------\n"
			"Echo of Ruin":
				global.main_text.text += "Echo of Ruin:\n Unleash a devastating wave of pleasure and pain. Be careful of allies that can't move out\n of the way. Skill has a 1 turn cooldown."
				global.main_text.text += "\n------------------------\n"
			"Daemonic Advance":
				global.main_text.text += "Daemonic Advance:\n Unleash a cluster of large ungulating tentacles that slam and grasp enemies."
				global.main_text.text += "\n------------------------\n"
			"Struggle":
				global.main_text.text += "Struggle:\n Fight to the best of your ability without a weapon."
				global.main_text.text += "\n------------------------\n"
			"Clang!":
				global.main_text.text += "Clang!:\n Big weapon go bonk!"
				global.main_text.text += "\n------------------------\n"
			"Colossal Weapon":
				global.main_text.text += "Colossal Weapon:\n Your weapon is so intimidating it raises your threat and when you do swing it, it\nbypasses any defence."
				global.main_text.text += "\n------------------------\n"
			#armor
				

func skip_turn(seeker):
	global.main_text.text += "\n------------------------\n"
	current_turn += 1
	seeker.lust += randi_range(6,10)
	update_stamina_lust(seeker,false,true)
	process_turns()

func back_to_skill_select(seeker,current_text, back_button):
	seeker = active_turn
	global.main_text.text = current_text
	global.button_container.remove_child(back_button)
	player_turn(seeker)
	

func create_swarm(swarm_stats):
	main_enemy_container.show()
	main_enemy_health.max_value = swarm_stats.hp
	main_enemy_health.value = swarm_stats.hp
	main_enemy_hp_label.text = "HP: " + str(swarm_stats.hp)
	main_enemy_heat.max_value = 20
	main_enemy_heat.value = swarm_stats.heat
	main_enemy_heat_label.text = "Heat: " + str(swarm_stats.heat)
	


func update_ui():
	main_enemy_health.value = swarm_stats.hp
	main_enemy_hp_label.text = "HP: " + str(swarm_stats.hp)
	main_enemy_heat.value = swarm_stats.heat
	main_enemy_heat_label.text = "Heat: " + str(swarm_stats.heat)
	

func victory():
	# do not restore unless the end of the dungeon, put that logic in dungeon crawling. but for testing have it here
	#move all seekers in other lists like orgy and ridden to active
	global.main_text.text += "\n------------------------\nThe goblins have been defeated! only a couple stragglers remain as they flee yelling curses.\n\n"
	for seeker in knocked_down_seekers:
		print(seeker.title)
		active_seekers.append(seeker)
	knocked_down_seekers.clear()
		# damsel memory because she was saved.
	for seeker in ridden_seekers:
		print(seeker.title)
		active_seekers.append(seeker)
	ridden_seekers.clear()
	for seeker in active_seekers:
		print(seeker.title)
		cooldowns(seeker)
		var memory_goblin_superiority = randi_range(1,10)
		seeker.status.clear() #maybe have some status stay after combat like horbny where lust rises each turn.
		if "Overconfident" in seeker.quirks and memory_goblin_superiority >= 6 and seeker.stamina != 0: #make like one, high for testing purpose
			seeker.memories.append("Superior to Goblins")
			global.main_text.text += "\n\n[color=orchid]" + str(seeker.title) + " savors this triumph and considers herself truly greater then goblins. She has gained the \"Superior to Goblins\" memory. [/color] " #have a memory if losing to goblins and has this memory something like "lost to inferior goblins!"
	global.clear_seeker_buttons()
	var victory = Button.new()
	victory.text = "Victory"
	global.button_container.add_child(victory)
	victory.pressed.connect(Callable(global,"returning").bind("victory", active_seekers))
	global.left_buttons.append(victory)

func loss():
	print(active_seekers)
	global.clear_seeker_buttons()
	for seeker in knocked_down_seekers:
		active_seekers.append(seeker)
		# damsel memory because she was saved.
	knocked_down_seekers.clear()
	for seeker in ridden_seekers:
		active_seekers.append(seeker)
	ridden_seekers.clear()
	print(active_seekers)
	for seeker in active_seekers:
		cooldowns(seeker)
		global.recovery_mission.append(seeker)
		global.departing.clear()
		var humiliating_defeat = randi_range(1,10)
		seeker.status.clear() #maybe have some status stay after combat like horbny where lust rises each turn.
		if "Overconfident" in seeker.quirks and humiliating_defeat >= 6: #make like one, high for testing purpose
			seeker.memories.append("Lost to Goblins")
			if "Overconfident" in seeker.quirks:
				seeker.quirks.erase("Overconfident")
	var loss = Button.new()
	loss.text = "Defeat"
	global.button_container.add_child(loss)
	loss.pressed.connect(Callable(global,"returning").bind("goblin loss", []))
	global.left_buttons.append(loss)
	#use recovery_orb
	# return to main menu

func knocked_down_seeker_turn(seeker):
	global.main_text.text += "\n------------------------\n" + str(seeker.title) + " is prone.\n\n"
	var skill_list = ["Push Away", "Scramble", "Cover up", "Distract", "Outlast"]
	var skill_check_1 = skill_list[randi_range(0,skill_list.size() - 1)]
	var skill_check_roll_1 = randi_range(5,50)
	var skill_check_2 = skill_list[randi_range(0,skill_list.size() - 1)]
	var skill_check_roll_2 = randi_range(5,50)
	var sex_skill_list = ["Handjob", "Blowjob", "Titjob", "Vaginal", "Anal"]
	var sex_skill_use = sex_skill_list[randi_range(0,sex_skill_list.size() - 1)]
	var success_points = 0
	var escape_chance = randi_range(1,3)
	if seeker.lust >= seeker.max_lust * 0.5 and escape_chance != 3:
		match sex_skill_use:
			"Handjob":
				global.main_text.text += str(seeker.title) + " uses her hand to grasp and jerk off a nearby goblin standing over her."
				goblin_ejaculation(seeker, "knocked_down_active_handjob")
			"Blowjob":
				global.main_text.text += str(seeker.title) + " helps guide a lengthy goblin schlong into her hot mouth. As it enters she doesn't waste time, bobbing her head lustfully slopily cleaning his rock hard member."
				goblin_ejaculation(seeker, "knocked_down_active_blowjob")
			"Titjob":
				global.main_text.text += str(seeker.title) + " wraps her bosum around a nearby goblins prick and starts servicing it with her " + str(seeker.breast_type) + " tits."
				goblin_ejaculation(seeker, "knocked_down_active_titjob")
			"Vaginal":
				global.main_text.text += str(seeker.title) + " pushes over an over zealous goblin causing him to fall onto his back, taking the opportunity she crawls ontop of him and before he even has a chance to react " + str(seeker.title) + " slams her wet pussy onto his thick shaft. "
				goblin_ejaculation(seeker, "knocked_down_active_vaginal")
			"Anal":
				global.main_text.text += str(seeker.title) + " feels a goblin thrust his shaft between her ass cheeks, his hot throbing rod glides lecherously in the valley, tantilisingly close to her back door. Unable to resist the teasing she leans away before slamming all the way back on his dick, lancing it deep into her ass as they both share an orgasmic cry of surprise and sublime pleasure."
				goblin_ejaculation(seeker, "knocked_down_active_anal")
	else:
		if escape_chance == 3:
			global.main_text.text += str(seeker.title) + " is able to stand up!\n\n"
			active_seekers.append(seeker)
			knocked_down_seekers.erase(seeker)
			process_turns()
		else:
			match skill_check_1:
				"Push Away":
					if seeker.strength >= skill_check_roll_1 * 1.5:
						success_points += 2
						global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold to restrain her they are quickly tossed and shaken off as she struggles free."
					elif seeker.strength >= skill_check_roll_1:
						success_points += 1
						global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold to restrain her they are quickly tossed and shaken off as she struggles free."
					else: 
						seeker.stamina -=  3
						#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
						global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold and restrain her. She bucks wildly unable to free herself from their grasp as the goblins prepare for the next step."
				"Scramble":
					if seeker.agility >= skill_check_roll_1 * 1.5:
						success_points += 2
						global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and fully succeeds, able to stand up and get ready for their next move."
					elif seeker.agility >= skill_check_roll_1:
						success_points += 1
						global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and succeeds, crawling away from being surrounded, but the goblins follow her movements."
					else: 
						swarm_stats.heat += 3
						if swarm_stats.heat >= 20:
							swarm_stats.heat = 20
						#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
						global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and succeeds, until a goblin catches her legs and pulls her back into the group's centre."
				"Outlast":
					if seeker.durability >= skill_check_roll_1 * 1.5:
						success_points += 2
						global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her. she notices shes draining the nearby goblin's strength like a succubus and takes the opportunity to simply get up and leave."
					elif seeker.durability >= skill_check_roll_1:
						success_points += 1
						global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her. At this rate though she should be able to find an oppening when the goblins tire."
					else: 
						seeker.lust +=  5
						#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
						global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her, her plan is to tire out the goblins to give herself an opportunity to escape. Unfortunately for her, her plan back fires as she archs her back and squirts to the goblins agressive and energetic forplay."
				"Distract":
					if seeker.intelligence >= skill_check_roll_1 * 1.5:
						success_points += 2
						global.main_text.text += str(seeker.title) + " starts by distract the goblins with her body and eroticism to give herself room to atleast stand up. She strikes poses and talks suggestively about how hot she feels by being watched. The goblins masturbate to her performance which goes on long enough for her to pose standing and when she asks for the goblins to close their eyes to recieve thier gift, she bolts out of there."
					elif seeker.intelligence >= skill_check_roll_1:
						seeker.lust +=  1
						success_points += 1
						global.main_text.text += str(seeker.title) + " distracts the goblins with her body and eroticism with the aim to give herself room to atleast stand up. She strikes poses and talks suggestively about how hot she feels by being watched. The goblins masturbate to her performance but it's not enough to find an escape route."
					else: 
						seeker.lust +=  5
						#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
						global.main_text.text += str(seeker.title) + " starts to distract the goblins with her body and eroticism in order to give herself room to atleast stand up. but it backfires she is quickly assualted by the goblins which start rubbing their meat against her, begging her to jerk them off."
				"Cover up":
					if seeker.intelligence >= skill_check_roll_1 * 1.5:
						success_points += 2
						global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get slightly bored with how stingy shes being. They quickly lose interest and " + str(seeker.title) + " gladly takes the opportunity to sneak away."
					elif seeker.intelligence >= skill_check_roll_1:
						seeker.lust +=  1
						success_points += 1
						global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get slightly bored with how stingy shes being. If they let their guard down just a tiny bit more she'll be able to escape."
					else: 
						swarm_stats.heat += 3
						if swarm_stats.heat >= 20:
							swarm_stats.heat = 20
						#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
						global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get angry with how prunish shes being. They lecherously ply her arms and legs open for everyone to witness how wet she truly is."
			if success_points <= 1:
				global.main_text.text += "\n\n"
				match skill_check_2:
					"Push Away":
						if seeker.strength >= skill_check_roll_1 * 1.5:
							success_points += 2
							global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold to restrain her they are quickly tossed and shaken off as she struggles free and stands up."
						elif seeker.strength >= skill_check_roll_1:
							success_points += 1
							global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold to restrain her they are quickly tossed and shaken off as she struggles free."
						else: 
							seeker.stamina +=  3
							#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
							global.main_text.text += "A a bunch goblins dive onto " + str(seeker.title) + " and grab hold and restrain her. She bucks wildly unable to free herself from their grasp as the goblins prepare for the next step."
					"Scramble":
						if seeker.agility >= skill_check_roll_1 * 1.5:
							success_points += 2
							global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and fully succeeds, able to stand up and get ready for their next move."
						elif seeker.agility >= skill_check_roll_1:
							success_points += 1
							global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and succeeds, crawling away from being surrounded but the goblins follow close behind."
						else: 
							swarm_stats.heat += 3
							if swarm_stats.heat >= 20:
								swarm_stats.heat = 20
							#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
							global.main_text.text += str(seeker.title) + " attempts to scramble out of the group of goblins and succeeds, until a goblin catches her legs and pulls her back into the group's centre."
					"Outlast":
						if seeker.durability >= skill_check_roll_1 * 1.5:
							success_points += 2
							global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her. she notices shes draining the nearby goblin's strength like a succubus and takes the opportunity to simply get up and leave."
						elif seeker.durability >= skill_check_roll_1:
							success_points += 1
							global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her. At this rate though she should be able to find an oppening when the goblins tire."
						else: 
							seeker.lust +=  5
							#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
							global.main_text.text += str(seeker.title) + " starts kissing and carressing the goblins as they do the same to her, her plan is to tire out the goblins to give herself an opportunity to escape. Unfortunately for her, her plan back fires as she archs her back and squirts to the goblins agressive and energetic forplay."
					"Distract":
						if seeker.intelligence >= skill_check_roll_1 * 1.5:
							success_points += 2
							global.main_text.text += str(seeker.title) + " starts by distracting the goblins with her body and eroticism to give herself room to atleast stand up. She strikes poses and talks suggestively about how hot she feels by being watched. The goblins masturbate to her performance which goes on long enough for her to pose standing and when she asks for the goblins to close their eyes to recieve thier gift, she bolts out of there."
						elif seeker.intelligence >= skill_check_roll_1:
							seeker.lust +=  1
							success_points += 1
							global.main_text.text += str(seeker.title) + " distracts the goblins with her body and eroticism with the aim to give herself room to atleast stand up. She strikes poses and talks suggestively about how hot she feels by being watched. The goblins masturbate to her performance giving her a chance to find a way to escape."
						else: 
							seeker.lust +=  5
							#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
							global.main_text.text += str(seeker.title) + " starts to distract the goblins with her body and eroticism in order to give herself room to atleast stand up. but it backfires she is quickly assualted by the goblins which start rubbing their meat against her, begging her to jerk them off."
					"Cover up":
						if seeker.intelligence >= skill_check_roll_1 * 1.5:
							success_points += 2
							global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get slightly bored with how stingy shes being. They quickly lose interest and " + str(seeker.title) + " gladly takes the opportunity to sneak away."
						elif seeker.intelligence >= skill_check_roll_1:
							seeker.lust +=  1
							success_points += 1
							global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get slightly bored with how stingy shes being. If they let their guard down just a tiny bit more she'll be able to escape."
						else: 
							swarm_stats.heat += 3
							if swarm_stats.heat >= 20:
								swarm_stats.heat = 20
							#maybe have restraint loving memory and fetish, also rape fantasy. where they don't resist
							global.main_text.text += str(seeker.title) + " covers up her erotic body causing the goblins to jeer and get angry with how prunish shes being. They lecherously ply her arms and legs open for everyone to witness how wet she truly is."
			if success_points >= 2:
				global.main_text.text += "\n\n" + str(seeker.title) + " is able to escape!\n\n"
				active_seekers.append(seeker)
				knocked_down_seekers.erase(seeker)
				process_turns()
				update_stamina_lust(seeker,true,true)
			else:
				global.main_text.text += "\n\n" + str(seeker.title) + " is unable to escape from the crowd of Goblins."
				current_turn += 1
				global.main_text.text += "\n------------------------\n"
				update_stamina_lust(seeker,true,true)
				update_ui()
				process_turns()


func goblin_ejaculation(seeker, sex_type):
	var ejaculation_amount = randi_range(5,100)
	var ejaculation_location = []
	var damage
	var chosen_location 
	var randomize_fetish = []
	var chosen_fetish
	var chosen_text = false
	for fetish in seeker.fetishes:
		randomize_fetish.append(fetish)
	randomize_fetish.shuffle()
	match randomize_fetish:
		"Cum Waster":
			chosen_fetish = "Cum Waster"
		"Cum Addicted":
			chosen_fetish = "Cum Addicted"
		"Cum Rag":
			chosen_fetish = "Cum Rag"
		"Dick Drainer":
			chosen_fetish = "Dick Drainer"
		"Handjob Expert":
			chosen_fetish = "Handjob Expert"
		"Cock Worship":
			chosen_fetish = "Cock Worship"
		_:
			pass
	if sex_type == "knocked_down_active_blowjob":
		damage = randi_range(5,10)
		ejaculation_location = ["onto the ground", "onto her " + str(seeker.breast_type) + " breasts", " down her throat", "onto her face", "into her hair", "onto her stomach", "into her mouth"]
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
		#logic here
		swarm_stats.hp -= damage
		if chosen_text == false:
			if chosen_location == "down her throat":
				global.main_text.text += " looks up at his pleasure distorted face pleased with her technique she decides to take it up a notch, recklessly pushing her gaping messy mouth deeper and deeper on his turgid dick, saliva bubbling out and splatting all over the place. tears start to form at her eyes but they aren't from despair. She feels his cock throb that special kind of twitch and as she pushes one final time throating the dick fully to the base she gags and chokes awaiting for her reward. The goblin ejaculates " + str(ejaculation_amount) + "ml of cum " + str(chosen_location) + ". Causing[color=red] " + str(damage) + "[/color] damage to the goblins."
			else:
				global.main_text.text += " looks up at his pleasure distorted face pleased with her technique she decides to take it up a notch, recklessly pushing her gaping messy mouth deeper and deeper on his turgid dick, saliva bubbling out and splatting all over the place. tears start to form at her eyes but they aren't from despair. She feels his cock throb that special kind of twitch and as she pushes one down to the base before she pells her lips off with an wet obscene \" pah\". The goblin jerks himself off to completion ejaculating " + str(ejaculation_amount) + "ml of jizz " + str(chosen_location) + ". Causing[color=red] " + str(damage) + "[/color] damage to the goblins."
	if sex_type == "knocked_down_active_titjob":
		damage = randi_range(5,10)
		ejaculation_location = ["onto the ground", "onto her " + str(seeker.breast_type) + " breasts", "down her throat", "onto her face", "into her hair", "onto her stomach", "into her mouth"]
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
		#logic here
		swarm_stats.hp -= damage
		if chosen_text == false:
			if chosen_location == "down her throat":
				global.main_text.text += " She continues to slide her breasts up and down the goblins shaft with increasing vigor. with each downward thrust she makes sure she's pumping his entire cock and feeling the full pleasure of her soft tits. " + str(seeker.title) + " feels the goblin pulse between her breasts, knowing that she mercilissly attacks his dick even wrapping her lips around the tip and with that The goblin ejaculates " + str(ejaculation_amount) + "ml of cum " + str(chosen_location) + ". Causing[color=red] " + str(damage) + "[/color] damage to the goblins."
			else:
				global.main_text.text += " She continues to slide her breasts up and down the goblins shaft with increasing vigor. with each downward thrust she makes sure she's pumping his entire cock and feeling the full pleasure of her soft tits. " + str(seeker.title) + " feels the goblin pulse between her breasts, knowing that she mercilissly attacks his dick grinding her " + str(seeker.breast_type) + " with all her might against the goblin's formidable cock, he is unable to last and climaxes. The goblin ejaculates " + str(ejaculation_amount) + "ml of cum " + str(chosen_location) + ". Causing[color=red] " + str(damage) + "[/color] damage to the goblins."
	if sex_type == "knocked_down_active_anal":
		damage = randi_range(5,10)
		ejaculation_location = ["into her ass"]
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
		#logic here
		swarm_stats.hp -= damage
		if chosen_text == false:
			global.main_text.text += " Slowly " + str(seeker.title) + " allows the cock to expand her tight asshole, the goblin being a goblin though is here to fuck and fuck hard, he ups the pace aggressively causeing " + str(seeker.title) + " to groan and make a face contorted by a mix of pain and bliss. Once the goblins rough pace sinks in she fights back, slamming back and crushing his cock with her grip. It doesn't take long for the goblin to reach his limit as the goblin ejaculates " + str(ejaculation_amount) + "ml of cum " + str(chosen_location) + " he wrenches his softening cock free but even still it stretches her ass even on the way out causing her expanded hole to gape for more abuse. The damage causing[color=red] " + str(damage) + "[/color] to the goblins."
	if sex_type == "knocked_down_active_vaginal":
		damage = randi_range(5,10)
		ejaculation_location = ["into her womb"]
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
		#logic here
		swarm_stats.hp -= damage
		if chosen_text == false:
			global.main_text.text += str(seeker.title) + " squirms in pleasure, climaxing from the girthy shaft hilting into her mushy wet pussy. Its not enough, she needs to be bred. She begins lewdly sliding up and down the Goblin's rock hard rod, that bends in all the right ways, prodding and poking her walls and weak spots vigilantly. " + str(seeker.title) + " moans and writhes at every new pleasurable grind and bump and before she knows it his tip kisses her wanting womb. Now the fun begins, she raises up slowly the cock slowing departing from her soaked passage before confidently and obscenly slamming back down, causing a wet plap and a spray of squirt, she continues fucking herself with his monstrous shaft until she feels the fated pulse, the goblin thrusts forward pushing his dick deep into her pussy and with a glorious burst ejaculates " + str(ejaculation_amount) + "ml of cum into her vulnerable vagina. With a naughty plop " + str(seeker.title) + " detaches herself from the goblin her pussy sloppy and full. Causing[color=red] " + str(damage) + "[/color] damage to the goblins."
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
	if sex_type == "knocked_down_active_handjob":
		damage = randi_range(5,10)
		ejaculation_location = ["onto the ground", "onto her " + str(seeker.breast_type) + " boobs", " which coats her hands", "onto her face", "into her hair", "onto her stomach", "into her mouth"]
		chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
		if chosen_fetish == "Cum Waster":
			swarm_stats.heat += randi_range(5,10)
			if swarm_stats.heat >= 20:
				swarm_stats.heat = 20
			damage += 5
			chosen_text = true
			ejaculation_location = ["onto the ground " + str(seeker.title) + " giggles at his worthless climax.", "back onto himself " + str(seeker.title) + " enjoys the goblins frustrated glare."]
			chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
			global.main_text.text += "\n\n" + str(seeker.title) + ": Are you getting close.\n\n"
			global.main_text.text += " Her skilled technique allows her to take control of the goblin body and lust. His cock spasms rapidly and he groans in delight\n\n" + str(seeker.title) + ": Thats it, get even closer.\n\n" + "Fondling and stroking his shaft forcing his obedience as he cums " + str(ejaculation_amount) + "ml " + str(chosen_location)
		elif chosen_fetish == "Cum Addicted":
			seeker.lust += randi_range(5,10)
			seeker.stamina += randi_range(5,10)
			chosen_text = true
			ejaculation_location = ["into her gaping mouth where she nosilily and pervertedly gulps down her prize", "into her waiting cupped hands, where she quickly slurps down the treat"]
			chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
			global.main_text.text += "\n\n" + str(seeker.title) + ": Come on, let me drink your delicious hot cum!\n\n"
			global.main_text.text += " Her skilled technique allows her to take control of the goblin body and lust, fondling and stroking his shaft forcing his obedience as he cums " + str(ejaculation_amount) + "ml " + str(chosen_location)
		elif chosen_fetish == "Cum Rag":
			ejaculation_amount += 50
			damage += 5
			chosen_text = true
			ejaculation_location = ["onto her " + str(seeker.breast_type) + " tits", "all over her face", "into her hair and face", "onto her gyrating body"]
			chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
			global.main_text.text += "\n\n" + str(seeker.title) + ": More, give me more cocks and paint me with your burning jizz!\n\n"
			global.main_text.text += " The goblins surround her upper body getting real close, their eagerness only matched by " + str(seeker.title) + " She uses her hands to stimulate as many cocks as she can. Soon cocks erupt " + str(ejaculation_amount) + "ml of piping hot cloudy sperm" + str(chosen_location)
		elif chosen_fetish == "Orgasm Denial":
			ejaculation_amount = 0
			damage += 3
			swarm_stats.heat += 5
			if swarm_stats.heat >= 20:
				swarm_stats.heat = 20
			chosen_text = true
			global.main_text.text += " The goblin thrusts into her hand and " + str(seeker.title) + " feels him getting close to bursting. After some intense stroking he's about to blow, she looses her grip and giggles as pre drips from his engorged twitching tip.\n\n" + str(seeker.title) + ": Oh? Did you want to cum?\n\n The gobbos not going to be happy when he comes down from his high."
		elif chosen_fetish == "Nimble Fingers":
			chosen_text = true
			damage + randi_range(3,8)
			" With her talented fingers " + str(seeker.title) + " gets to work servicing the goblin's dick in ways he could only imagine. With a powerful climax he ejaculates " + str(ejaculation_amount) + "ml of cum" + str(chosen_location)
		elif chosen_fetish == "Handjob Expert" or chosen_fetish == "Nimble Fingers":
			damage + randi_range(5,15)
			chosen_text = true
			" With handjobs being a specialty of " + str(seeker.title) + " her nimble fingers squeeze and pull with erotic finesse servicing the goblin's cock in ways he could only imagine. With a powerful climax he ejaculates " + str(ejaculation_amount) + "ml of cum" + str(chosen_location)
		elif chosen_fetish == "Dick Drainer":
			damage + randi_range(5,15)
			var second_orgasm = randi_range(5,20)
			chosen_text = true
			" with such an impressively stiff and manly cock infront of her she can't help but to rub it in worship. As the goblin reaches his peak he orgasms " + str(ejaculation_amount) + "ml of cum" + str(chosen_location) + " but she doesn't stop! While in the aftermath of the orgasm she continues vigorisly and mecislisely stroking his cock until more cum spurts out of the tired cock. Even then she continues torturing him making him cum " + str(second_orgasm) + " ml of extra cum."
		elif chosen_fetish == "Cock Worship":
			seeker.lust += randi_range(5,10)
			seeker.stamina += randi_range(5,10)
			chosen_text = true
			ejaculation_location = ["onto her " + str(seeker.breast_type) + " tits", "onto her hot steamy body"]
			chosen_location = ejaculation_location[randi_range(0,ejaculation_location.size() - 1)]
			global.main_text.text += "\n\n" + str(seeker.title) + ": Bring that marvelous meat here, i want to be smothered in its glory.\n\n"
			" " + str(seeker.title) + " pulls the goblin by his cock so that he's kneeling over her face. As she jerks it with an underhand grip she slurps and kisses the underside of his dick and balls drowing in it's perverted musk. eventaually and too soon for " + str(seeker.title) + " the goblin cums " + str(ejaculation_amount) + "ml of cum" + str(chosen_location)
		swarm_stats.hp -= damage
		if chosen_text == false:
			global.main_text.text += " Not caring about his pleasure she roughly mills his cock with two hands until he ejaculates " + str(ejaculation_amount) + "ml of cum " + str(chosen_location) + ". Causing[color=red] " + str(damage) + "[/color] damage."
		if chosen_text == true:
			global.main_text.text += ". Causing[color=red] " + str(damage) + "[/color] damage."
	seeker.lust += randi_range(1,5)
	if seeker.lust >= seeker.max_lust:
		seeker.lust = seeker.max_lust * randi_range(0.25,0.75)
		seeker.stamina -= randi_range(10,15)
		global.main_text.text += "\n\n" + str(seeker.title) + " orgasms! Squirting messily."
		global.main_text.text += "\n" + str(seeker.title) + ":\nNew Stamina: " + str(seeker.stamina) + "/" + str(seeker.max_stamina) + "\nNew Lust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	global.main_text.text += "\n------------------------\n"
	update_ui()
	current_turn += 1
	process_turns()


func ridden_turn(seeker):
	var buck_check = randi_range(1,80)
	if seeker.strength >= buck_check: 
		active_seekers.append(seeker)
		ridden_seekers.erase(seeker)
		global.main_text.text += str(seeker.title) + " tries to buck the rider off her back. and succeeds sending the goblin tumbling to the ground. She spits out the gag and stands up preparing for the continued fight."
		update_ui()
		current_turn += 1
		process_turns()
	elif active_seekers.size() >= 1:
		var target_choice
		for target in active_seekers:
			target_choice = target
		var damage = randi_range(4,8)
		if "Warded" in target_choice.status:
			damage = 0
			global.main_text.text += "\n" + str(seeker.title) + " follows her rider's commands charging at " + str(target_choice.title) + " the goblin swings his club but it is deflected by her ward."
		else:
			target_choice.stamina += damage
			global.main_text.text += "\n" + str(seeker.title) + " follows her rider's commands charging at " + str(target_choice.title) + " the goblin strikes her knee with his solid club. Dealing[color=red] " + str(damage) + "[/color]."
		update_ui()
		current_turn += 1
		process_turns()
	elif ridden_seekers.size() >= all_seekers.size():
		if all_seekers.size() >= 2:
			loss()
			global.main_text.text += "The Goblins cry in victory! They gather up their new breeding whores and start leading them back to their village."
			
		else:
			loss()
			global.main_text.text += "The Goblins cry in victory! They gather up their new breeding whore and start leading them back to their village."
	global.main_text.text += "\n------------------------\n"

func inspect_choice(seeker, inspect_text):
	global.clear_seeker_buttons()
	if inspect_current_text == "":
		inspect_current_text = global.main_text.text
		print(inspect_current_text)
	global.main_text.text = str(inspect_current_text)
	for i in active_seekers:
		var inspect_button = Button.new()
		inspect_button.text = i.title
		global.button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "inspect").bind(i, "active"))
		global.left_buttons.append(inspect_button)
	for ii in knocked_down_seekers:
		var inspect_button = Button.new()
		inspect_button.text = ii.title
		global.button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "inspect").bind(ii, "knocked down"))
		global.left_buttons.append(inspect_button)
	for iii in ridden_seekers:
		var inspect_button = Button.new()
		inspect_button.text = iii.title
		global.button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "inspect").bind(iii, "ridden"))
		global.left_buttons.append(inspect_button)
	var back_button = Button.new()
	back_button.text = "Back"
	global.button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "back_to_skill_select").bind(seeker,inspect_current_text,back_button))
	global.left_buttons.append(back_button)
	

func inspect(seeker, state,):
	global.clear_seeker_buttons()
	global.main_text.text = str(inspect_current_text)
	global.main_text.text = "\n"
	global.main_text.text += "------------------------"
	global.main_text.text += "\nSeeker Name: " + seeker.title
	global.main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	global.main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	global.main_text.text += "\n"
	global.main_text.text += "\nStrength: " + str(seeker.strength)
	global.main_text.text += "\nAgility: " + str(seeker.agility)
	global.main_text.text += "\nDurability: " + str(seeker.durability)
	global.main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	global.main_text.text += "\nWill: " + str(seeker.will)
	global.main_text.text += "\nThreat: " + str(seeker.threat)
	global.main_text.text += "\n"
	global.main_text.text += "\nSkills: " + str(seeker.skills)
	global.main_text.text += "\nQuirks: " + str(seeker.quirks)
	global.main_text.text += "\nFetishes: " + str(seeker.fetishes)
	global.main_text.text += "\n"
	global.main_text.text += "\nDescription: " + seeker.description
	global.main_text.text += "\n"
	global.main_text.text += "\nWeapon: " + seeker.weapon
	global.main_text.text += "\nArmor: " + seeker.armor + "\n\n"
	if state == "active":
		if seeker.lust <= seeker.max_lust * 0.5:
			global.main_text.text += str(seeker.title) + " is ready to slay some Goblins!"
		else:
			global.main_text.text += str(seeker.title) + " is too horny to fight and instead needs to fuck!"
	if state == "knocked down":
		if seeker.lust <= seeker.max_lust * 0.5:
			global.main_text.text += str(seeker.title) + " is knocked down and surrounded by Goblins! She is trying to escape."
		else:
			global.main_text.text += str(seeker.title) + " is knocked down surrounded by goblins and is super aroused!"
	if state == "ridden":
		if seeker.lust <= seeker.max_lust * 0.5:
			global.main_text.text += str(seeker.title) + " is being ridden like a pony and can't fight back!"
		else:
			global.main_text.text += str(seeker.title) + " is being ridden like a sow, her pussy dripping with excitement!"
	global.main_text.text += "\n------------------------\n\n"
	var back_button = Button.new()
	back_button.text = "Back"
	global.button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "inspect_choice").bind(seeker,inspect_current_text))
	global.left_buttons.append(back_button)


func update_stamina_lust(seeker,stamina_changed,lust_changed):
	if seeker.lust > seeker.max_lust:
		seeker.lust = seeker.max_lust * randi_range(0.25,0.75)
		global.main_text.text += "\n\n" + str(seeker.title) + " orgasms! Squirting messily."
		stamina_changed = true
		seeker.stamina -= randi_range(10,15)
	if seeker.stamina > seeker.max_stamina:
		seeker.stamina = seeker.max_stamina
	if stamina_changed == true:
		global.main_text.text += "\n\n" + str(seeker.title) + "\nNew Stamina: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	if lust_changed == true:
		global.main_text.text += "\n\n" + str(seeker.title) + "\nNew Lust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	global.main_text.text += "\n------------------------\n\n"
# keep adding skills including armor
# add goblin actions and display like hp
# elif for ridden then knocked_down goblin actions if there are no active seekrs
# test knocked down and sex, do these edits for testing, add half of seekers lust, change all possible sex skills to handjobs, give multiple of the fetishes and check if they are being applied by putting prints in their logic
# add sexskills when lust is half full based on desires
# add goblin gangbang
# add memories, ideas: seeing masturbation, seeing sex, seeing brutality from goblins, seeing a seeker engage sex, seeing two seekers have sex, see a goblin get angry, kill a goblin with aoe, perform: blowjob, handjob, footjob, titjob, vaginal, anal, rimjob, gangbang, bukkake, used while unconscious, sex toy insertion, rough sex, ryona, pissed on
# add goblin minions, alpha, loot goblins, brood mothers?
# look into button errors, it works for now but output is not liking it
#have unlocks behind fetishes like anal slut being after likes anal or something
# memory list: "Superior to Goblins", "Bite Mark", "Spanked", "Erotic Injury", "Breasts toyed with", "Climax", "Ass Gropped"
# Fetish list: "Fuck Meat", "Sadistic Stimulator", "Pain Slut", "Sensitive Ass", "Sensitive Breasts", "Sensitive Pussy", "Sensitive Mouth", "Cum Waster", "Cum Addicted", "Cum Rag", "Handjob Expert", "Dick Drainer", "Cock Worship"
# APPLY THE FOLLOWING STATUS: Warded: reduces damage to 0. increases lust
#bug: character 1 faints, character 2 has no options to act. no other text so likely a = somewhere
