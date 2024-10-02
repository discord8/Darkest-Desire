extends Control

class_name Seeker
var title: String
var corruption_level = 0 #have fetish give out corruption points then based on corruption level determines what tier of mission they go on.
var stamina: int = 0
var max_stamina: int = 0
var lust: int = 0#at half change skills to sex skills
var max_lust: int = 100 #
var intelligence: int = 0 #crit
var will: int = 0#mental resist
var agility: int = 0#dodge and agility weapons
var equip_agility: int = 0 #to stop the unequip bug
var strength: int = 0#extra damage for melee weapons, curios
var durability: int = 0#extra stamina, resist poison
var quirks: Array #quirks can evolve into fetishes, fetishes offer xp, xp allows for more perverted dungeons when gaining a fetish it comes intelligenceh benefits usually always a lust and stamina increase of about 10?
var fetishes: Array
var skills: Array
var skill_objects: Array
var desires: Array
var memories: Array
var description: String
var threat: int # higher the threat more likely to be targeted
var initiative_roll: int
var status: Array #prone, being fucked, blowjob etc
var weapon: String
var allows_weapon_strip: bool
var armor: String
var allows_armor_strip: bool
var trinket: Array
var pregnant: bool
var body_type: String
var eye_color: String
var hair_color: String
var hair_type: String
var breast_size: int
var lactation: String
var breast_type: String
var wears_glasses: bool
var posture: String
var weapon_description: String
var armor_description: String
var cooldown_1: Array
var cooldown_2: Array
var cooldown_3: Array
var cooldown_battle: Array
var intelligence_change: int
var will_change: int
var agility_change: int
var durability_change: int
var strength_change: int
var threat_change: int
var cum_milked: int #partially converted to PP
var PP: int #perversion points, used to determine rank
var has_cock: bool


#system vars
#viewing vars
#roster for seekers
var for_hire: Array = []
var roster: Array = []
var reflecting: Array = []
var exploring: Array = []
var departing: Array = []
var max_party_size = 3
# random lists
var armory = []
var armor_armory = []
var left_buttons = []
var right_buttons = []
var fetishes_list = ["Pain Slut", "Spankable Ass", "Orgasm Denier", "Goonete", "Masturbation Addict", "Degradation Slut", "Slave", "Struggle Fucking", "Corruption", "Trance Fucking", "Hypnotism", "Free Service", "Service Slut", "Voyeur", "Libidinous", "Hair Trigger", "Sadist", "Cock Miller", "Dick Drainer", "Skillful Fingers", "Matchmaker", "Mistress", "Temptress"]
var submissive_fetishes = ["Pain Slut", "Spankable Ass", "Degradation Slut", "Slave", "Trance Fucking", "Hypnotism", "Free Service", "Service Slut", "Voyeur", "Cock Miller"]
var bdsm_fetishes = ["Pain Slut", "Spankable Ass", "Degradation Slut", "Slave", "Struggle Fucking", "Free Service", "Service Slut"]
var dominant_fetishes = ["Orgasm Denier", "Voyeaur", "Libidinous", "Hair Trigger", "Sadist", "Cock Miller", "Dick Drainer", "Skillful Fingers", "Matchmaker", "Mistress", "Temptress"]
var perverted_fetishes = ["Orgasm Denier", "Goonete", "Corruption", "Trance Fucking", "Hypnotism", "Free Service", "Libidinous", "Hair Trigger", "Temptress", "Cock Miller", "Dick Drainer"]
var common_fetishes = ["Spankable Ass", "Masturbation Addict", "Struggle Fucking", "Corruption", "Free Service", "Voyeur", "Libidinous", "Temptress", "Skillful Fingers"]
var dick_fetish = []
var pussy_fetish = []
var ass_fetish = []
var oral_fetish = []
var breasts_fetish = []
var paras
var names = ["Lilica", "Vex", "Lara", "Tilly", "Mili", "Isabell", "Ivy", "Melody", "Melissa", "Anna", "Dorathy", "Jess", "Mika", "Eda", "Stacy", "Trish", "Stephanie", "Linda", "Molly", "Mandy", "Dakota", "Iyo", "Kairi", "Nia", "Peyton", "Yera", "Triena", "Aath", "Miu", "Mikan", "Tsumiki", "Miku", "Fili", "Sage", "Evelyn", "Lucy", "Emma", "Terial", "Lyra", "Titiana", "Nip", "Sarah", "Sara", "Mimi", "Octavia", "Corin", "Gigi", "Mandy", "Rose", "Liv", "Rhea", "Jasmine", "Piper", "Dove", "Jade", "Ingrid", "Umi", "Tori", "Cindy", "Velvet", "Mariah", "Tessa", "Tess", "Daphney", "Dora", "Zelda", "Hitomi", "Seras", "Ava", "Olivia", "Sophie", "Amelia", "Mary", "Isabella", "Victoria", "Charlotte", "Luna", "Mia", "Kalifa", "Lana", "Amber", "Gianna", "Annie", "Nora", "Layla", "Lilly", "Nikki", "Aoi", "Lulu", "Mami", "Hazel", "Madi", "Isla", "Willow", "Zoe", "Grace", "Ivy", "Naomi", "Maya", "Alice", "Sadie", "Hailey", "Aubrey", "Skye", "Vivian", "Eve", "Freya", "Amara", "Chel", "Catalina", "Ashley", "Chloe", "Faith", "Kimberly", "Taylor", "Sutton", "Vera", "Kaia", "Lilly", "Selena", "Aubrey", "Nyla", "Lia", "Kiara", "Elise", "Hope", "Lola", "Lilith", "Ophelia", "Dahlia", "Blair", "Celeste", "Rebecca", "Nina", "Trinity", "Vanessa", "Camilla", "Adrianna", "Celine", "Lucianna", "Reign", "Cali", "Viviana", "Serena", "Destiny", "Elle", "Veronica", "Azaela", "Raya", "Raven", "Scarlet", "Sylvie", "Lexi", "Ryn", "Carmen", "Alison", "Felicity", "Katalina", "Zariah", "Mira", "Jolene", "Emelia", "Bonnie", "Briar", "Leona", "Lina", "Remy", "Mina", "Mili", "Selene", "Angie", "Flora", "Violet", "Aya", "Ramona", "Bridget", "Mercy", "Paula", "Baylor", "Marianna", "Loretta", "Gwen", "Robin", "Katelyn", "Tiffany", "Lexie", "Kahlani"]
var all_weapons =["Twin Daggers", "Crossbow", "Flintlock", "Arcane Wand", "Animated Spellbook", "Broad Sword", "Battle Axes", "Great Club"]
var all_armors = ["Graceful Robes", "Bikini Armor", "Dancer's Silk", "Holy Garb", "Fantasy Fullplate", "Skimpy Streetrat"]
var starter_weapons = ["Twin Daggers", "Crossbow", "Animated Spellbook", "Great Club"]
var starter_armors = ["Graceful Robes", "Bikini Armor", "Skimpy Streetrat"]
# uprgrade vars
var fetish_cap = 0 #put at fetish generation, go up by 1 per level
var weapon_level = starter_weapons
var armor_level = starter_armors
var strength_cap = 28 #add 10 per level, observations can also increase by 1, put at end of generation
var agility_cap = 28
var durability_cap = 28
var intelligence_cap = 28
var will_cap = 28
var recruitables = 10
var starting_weapons = 3
var starting_armor = 3

func _init():
	self.title = names[randi_range(0,names.size() - 1)]
	self.intelligence = randi_range(12,intelligence_cap)
	self.will = randi_range(12,will_cap)
	self.agility = randi_range(12,agility_cap)
	self.durability = randi_range(12,durability_cap)
	self.strength = randi_range(12,strength_cap)
	self.threat = 20 #AT 0 NOT TARGETABLE, gather up party threat each round and roll
	self.intelligence_change = 0
	self.will_change = 0
	self.agility_change = 0 
	self.durability_change = 0
	self.strength_change = 0
	self.threat_change = 0 #AT 0 NOT TARGETABLE, gather up party threat each round and roll
	self.desires = [] #they will remember what happend to them and when they reflect they will choose one for an event. example if this girl was stripped she might remember she was bashful but it actually wasn't as bad as she thought it was and so she doesn't gain as must lust from being stripped. then she gains the new memory: heart oppening to exhibition, activates each round based on lust
	self.memories = []
	self.fetishes = []
	self.quirks = ["Overconfident"]
	self.skills = [] #names of skills for display
	self.skill_objects = [] #actual skills
	self.max_stamina = 10 + durability * 2
	self.stamina = max_stamina
	self.lust = 0
	self.max_lust = 10 + will * 2
	self.status = []
	self.weapon = weapon_level[randi_range(0,weapon_level.size() - 1)]
	self.allows_weapon_strip = false
	self.armor = armor_level[randi_range(0,armor_level.size() - 1)]
	self.allows_armor_strip = false
	self.trinket = []
	self.pregnant = false
	self.body_type = ""
	self.eye_color = ""
	self.hair_color = ""
	self.hair_type = ""
	self.breast_size = 0
	self.breast_type = ""
	self.wears_glasses = false
	self.posture = ""
	self.lactation = ""
	self.weapon_description = ""
	self.armor_description = ""
	self.description = ""
	self.cooldown_1 = [] #at end of round add these skills back
	self.cooldown_2 = [] #at end of round add these skills to cooldown_1
	self.cooldown_3 = [] #add to cooldown 2
	self.cooldown_battle = [] #one use skills go here add back at the end of battle
	self.cum_milked = 0 #partially converted to PP
	self.PP = 0 #perversion points, used to determine rank
	self.has_cock = false
	generate_quirks()
	generate_desires()
	
	

func generate_quirks():
	var all_generated_quirks = ["Durable", "Frail", "Strong", "Weak", "Aggressive","Lazy", "Energetic", "Resolute", "Corruptable", "Bright", "Dim","Bimbo", "Enlightened", "Talented", "Overconfident"]
	var num_of_quirks = randi_range (1,3)
	for i in range(num_of_quirks):
		var quirk = ""
		while true:
			quirk = all_generated_quirks[randi_range(0, all_generated_quirks.size() - 1)]
			if quirk not in quirks:
				quirks.append(quirk)
				break
		

func generate_desires():
	var starting_skills = ["Submit", "Fantasize", "Experiment", "Attract Attention", "Dominate"] #these skills branch off on observations which opens up what the girl is willing to intiate herself, they always consent.
	var num_of_skills = randi_range(1,3)
	for i in num_of_skills:
		desires.append(starting_skills[randi_range(0,starting_skills.size() - 1)])
#masturbate is perversion, fantasize is submissive, Experiment is common, Attract attention is bdsm, dominate is dominance

func generate_description(seeker):
	var lactation_chance
	var breast_size_roll = randi_range(0,7)
	#var physical_posture = ["She outwardly projects as quite normal", "She seems incredibly friendly", "She seems unaware of how erotic she is even in simple things like her stride", "She has a strong pheromone smell to her", "Her movements are arousingly feminine and erotic", "She makes sure to highlight how fit her bod is", "she pumps out her chest and moves with confidence", "She seems quick to anger","She sweats often and has a feminine musk about her", "She's a ball of energy hardly able to stay still", "She's disciplined and calm", "She stays in a combat stance, ready to go at a moments notice", "She seems serious and intense", "She stands tall, making herself look heroic", "She gives off childhood friend energy", "She struts and poses like a supermodel", "She struts around knowing how hot she really is",]
	#var mental_posture
	#var confident_posture = ["She outwardly projects as quite normal", "She seems incredibly friendly", "She has an air of elegance about her", "Her movements are arousingly feminine and erotic", "She makes sure to highlight herself in a sexual way", "she pumps out her chest and moves with confidence", "She seems quick to anger", "She's a ball of energy hardly able to stay still", "She's disciplined and calm", "She has a deviant glint in her eyes", "She stays in a combat stance, ready to go at a moments notice", "She seems serious and intense", "She stands tall, making herself look heroic", "She gives off childhood friend energy", "She gives off girl next door energy", "She's got milf aura with a dangerous look in her eyes, like she wants to eat me up.", "She struts around knowing how hot she really is", "She's entitled, asking for only the highest quality emenities"]
	#var negative_posture = ["She looks down upon you with disgust", "Her movements are arousingly feminine and erotic","She seems unaware of how erotic she is even in simple things like her stride", "She has a strong pheromone smell to her", "She sweats even from eye contact, she seems really pent up and held back.", "She sweats often and has a feminine musk about her", "She makes sure to highlight herself in a sexual way", "she seems shy and averts eye contact", "She seems quick to anger", "She acts like her intellect is greater than yours", "She's disciplined and calm", "She looks tired and yawns reguraly", "She has a deviant glint in her eyes when she isn't averting eye contact", "She seems serious and intense", "She's making herself look small with her stance by folding inwards", "She's got milf aura with an erotic body that demands to be dominated", "She seems jumpy and unsure of herself", "She seems depressed and constantly looks at the floor",]
	var boob_type = ["petite", "small", "ample", "large", "massive", "fabric Stretching", "gigantic", "unbelievably massive"]
	var posture = ["She has an air of elegance about her", "she's deranged with a long creepy smile", "Shes easily distracted, staring off into space", "She acts cute and reserved", "She likes getting close and personal batting her eyes and making people uncomfortable", "She looks down upon you with disgust", "She outwardly projects as quite normal", "She seems incredibly friendly", "She has a strong pheromone smell to her", "She sweats even from eye contact, she seems really pent up and held back.", "She sweats often and has a feminine musk about her", "She seems unaware of how erotic she is even with simple things like her stride", "She's very clumsy always tripping over herself", "she's talks and walks like a bimbo", "Shes very curious, always leaning forward to get a better look", "She keeps to herself mumbling something under her breath", "She's creepy, shes always watches from the shadows", "She loves to party, being right at home around the castle grounds", "Her movements are arousingly feminine and erotic","She seems unaware of how erotic she is even in simple things like her stride", "She has a strong pheromone smell to her", "She makes sure to highlight herself in a sexual way","She has a deviant glint in her eyes when she isn't averting eye contact", "she seems shy and averts eye contact", "she pumps out her chest and moves with confidence", "She seems quick to anger", "She's a ball of energy hardly able to stay still", "She's disciplined and calm", "She looks tired and yawns reguraly", "She has a deviant glint in her eyes", "She stays in a combat stance, ready to go at a moments notice", "She seems serious and intense", "She struts and poses like a supermodel", "She stands tall, making herself look heroic", "She's making herself look small with her stance", "She gives off childhood friend energy", "She gives off girl next door energy", "She's got milf aura that begs to be fucked", "She seems jumpy and unsure of herself", "She seems depressed and constantly looks at the floor", "She walks around knowing how hot she is", "She's entitled, asking for only the highest quality emenities"]
	var body_type_list = ["of average build", "fit and ripped", "obscenely thick", "short and slim", "amazonian in build", "tall and slender", "tall and voluptuous", "short and stacked", "proportioned like a walking fucktoy", "beautiful like a goddess", "bottom heavy", "curvy, with an hourglass figure", "chubby", "athletic", "thin and petite", "well proportioned" ]
	var eye_color_list = ["[color=aqua]sky blue[/color]", "[color=darkgreen]emerald green[/color]", "[color=blue]navy blue[/color]", "[color=peru]light brown[/color]", "[color=saddlebrown]dark brown[/color]", "[color=plum]lavender[/color]", "[color=magenta]dark purple[/color]", "[color=crimson]agressive red[/color]", "[color=gold]golden[/color]", "[color=hotpink]lustful pink[/color]"]
	var hair_type_list = ["wild and free", "That hides her eyes", "layered and beautiful", "that is short and cute", "pulled into a long ponytail", "pulled into a short ponytail", "short", "long and covering up one eye", "long and straight", "long and wavey", "long and messy", "stylised into pigtails", "partially shaven", "done up in a bun"]
	var hair_color_list = ["[color=crimson]crimson[/color]", "[color=orangered]fiery orange[/color]", "jet black", "[color=gray]soft black[/color]", "[color=silver]Silver[/color]", "snow white", "[color=peru]hazel[/color]", "[color=saddlebrown]dark brown[/color]", "[color=hotpink]light pink[/color]", "[color=magenta]magenta[/color]", "[color=chartreuse]spring green[/color]", "[color=darkgreen]dark green[/color]", "[color=aqua]light blue[/color]", "[color=yellow]bimbo blonde[/color]", "[color=navajowhite]platinum blonde[/color]", "[color=deepskyblue]vibrant blue[/color]"]
	#var glasses_chance = randi_range(1,10)
	seeker.breast_size = breast_size_roll
	print("breast1")
	print(seeker.breast_size)
	seeker.posture = str(posture[randi_range(0,posture.size() - 1)])
	seeker.body_type = str(body_type_list[randi_range(0,body_type_list.size() - 1)])
	seeker.eye_color = str(eye_color_list[randi_range(0,eye_color_list.size() - 1)])
	seeker.hair_color = str(hair_color_list[randi_range(0,hair_color_list.size() - 1)])
	seeker.hair_type = str(hair_type_list[randi_range(0,hair_type_list.size() - 1)])
	if seeker.body_type == "short and slim" or seeker.body_type == "fit and ripped" or seeker.body_type == "tall and slender" or seeker.body_type == "short and stacked" or seeker.body_type == "athletic" or seeker.body_type == "amazonian in build" and seeker.breast_size >= 1:
		seeker.breast_size -= 1
		if seeker.breast_size == 6:
			seeker.breast_size -= 1
		if seeker.body_type == "short and slim":
			seeker.strength -= 2
			seeker.will -= 2
			seeker.intelligence += 4
		if seeker.body_type == "tall and slender":
			seeker.agility -= 2
			seeker.durability -= 2
			seeker.intelligence += 4
		if seeker.body_type == "thin and petite":
			seeker.strength -= 4
			seeker.durability -= 4
			seeker.intelligence += 4
			seeker.agility += 4
		if seeker.body_type == "athletic":
			seeker.intelligence -= 4
			seeker.will -= 4
			seeker.agility += 4
			seeker.strength += 2
			seeker.durability += 2
		if seeker.body_type == "fit and ripped":
			seeker.intelligence -= 6
			seeker.will -= 6
			seeker.agility += 4
			seeker.strength += 4
			seeker.durability += 4
		if seeker.body_type == "amazonian in build":
			seeker.intelligence -= 6
			seeker.agility -= 4
			seeker.will -= 2
			seeker.strength += 6
			seeker.durability += 6
	if seeker.body_type == "obscenely thick" or seeker.body_type == "short and stacked" or seeker.body_type == "tall and voluptuous" or seeker.body_type == "beautiful like a goddess" or seeker.body_type == "proportioned like a walking fucktoy" or seeker.body_type == "curvy, with an hourglass figure" or seeker.body_type == "chubby" and seeker.breast_size <= 6:
		seeker.breast_size += 1
		if seeker.breast_size >= 8:
			seeker.breast_size -= 1
		if seeker.breast_size == 1:
			seeker.breast_size += 2
		if seeker.body_type == "obscenely thick":
			seeker.strength -= 4
			seeker.agility -= 4
			seeker.durability += 6
			seeker.will += 2
			lactation_chance = randi_range(1,12)
			if lactation_chance <= 7:
				seeker.lactation = "[b]milk dripping [/b]"
			if lactation_chance <= 2:
				seeker.lactation = "[b]lactating [/b]"
		if seeker.body_type == "tall and voluptuous":
			seeker.agility -= 4
			seeker.durability += 2
			seeker.strength += 2
			lactation_chance = randi_range(6,12)
			if lactation_chance <= 7:
				seeker.lactation = "[b]milk dripping [/b]"
		if seeker.body_type == "proportioned like a walking fucktoy":
			seeker.intelligence -= 4
			seeker.durability += 4
			lactation_chance = randi_range(1,12)
			if lactation_chance <= 7:
				seeker.lactation = "[b]milk dripping [/b]"
			if lactation_chance <= 2:
				seeker.lactation = "[b]lactating [/b]"
		if seeker.body_type == "curvy, with an hourglass figure":
			seeker.agility -= 2
			seeker.intelligence -= 2
			seeker.durability += 2
			seeker.will += 2
			lactation_chance = randi_range(6,12)
			if lactation_chance <= 7:
				seeker.lactation = "[b]milk dripping [/b]"
		if seeker.body_type == "chubby":
			seeker.agility -= 4
			seeker.durability += 2
			seeker.intelligence += 2
		if seeker.body_type == "short and stacked":
			seeker.will -= 6
			seeker.strength -= 6
			seeker.durability += 6
			seeker.intelligence += 3
			seeker.agility += 3
			lactation_chance = randi_range(1,12)
			if lactation_chance <= 7:
				seeker.lactation = "[b]milk dripping [/b]"
			if lactation_chance <= 2:
				seeker.lactation = "[b]lactating [/b]"
	if seeker.body_type == "well proportioned":
		seeker.will -= 3
		seeker.intelligence -= 3
		seeker.agility += 6
	print("breast2:")
	print(seeker.breast_size)
	seeker.breast_type = boob_type[seeker.breast_size]
	print(seeker.breast_type)
	update_description(seeker)
	
	#1/10 chance shes wearing glasses, lowering agility, use body types as a way to change stats down the line
	#add tits and random description also add
	#add posture
	

func update_description(seeker):
	print(seeker.stamina)
	#match seeker.weapon:
	match seeker.armor:
		"Naked":
			if "Overconfident" in seeker.quirks:
				seeker.armor_description = "She grins as people take in her stunning body, bravely displaying the figure she's so confident in."
			else:
				seeker.armor_description = "Shes been stripped completely. She's embarrassed and covers up instinctually." #gain barrier, gain threat, gain lust
		"Graceful Robes": #seductive sorcerer miniskirt upgrade
			seeker.armor_description = "An eye catching dress snugly carreses her supple form showing off her bust and leading down to a long skirt with a thigh high opening." #increases intelligence and will, lower threat. concentrate: next attack add intelligence to damage
		"Bikini Armor":
			seeker.armor_description = "She like many others is wearing impractical but tantalizing skimpy bikini armour with high heels that priortises her sex appeal over safety." #increase durability and strength by alot. Taunt: raises threat by alot gives half stamina as temp. once per battle
		"Dancer's Silk":
			seeker.armor_description = "Graceful, beautiful and thin cloth wrap her breasts and gentils combining to make a tantalisingly revealing costume, if you stare hard enough you can see right through the material." #Increases ddurability and agilkity. Encourage: remove a negative effect and give strength
		"Holy Garb":
			seeker.armor_description = "She adorns a corset styled dress with a salaciously short miniskirt. Venus's love radiates from it." #Increse will dramatically, lower threat. Service: increase lust but regain stamina
		"Fantasy Fullplate":
			if seeker.breast_size >= 5:
				seeker.armor_description = "She wearing modified full plate, with the chest removed to give her bountiful boobs some much needed breathing room."
			else:
				seeker.armor_description = "She's wearing full plate, it sports an easy pull off design and a boob window." #Increase Strenght and durability raise threat, lower agility and intelligence. Protected: start combat intelligenceh 1 barrier
		"Skimpy Streetrat":
			if seeker.breast_size >= 5:
				seeker.armor_description = "She wears tight booty shorts and a normally loose fitting tank top that is being stretched out to its limits."
			else:
				seeker.armor_description = "She wears tight booty shorts and a loose fitting tank top."
	if seeker.wears_glasses == true:
		seeker.description = "She is " + str(seeker.body_type) + " with " + str(seeker.lactation) + str(seeker.breast_type) + " breasts. She wears glasses and her eyes are " + str(seeker.eye_color) + ". She has " + str(seeker.hair_color) + " hair that is " + str(seeker.hair_type) + ". " + str(seeker.posture) + ". " + str(seeker.armor_description) 
	else:
		seeker.description = "She is " + str(seeker.body_type) + " with " + str(seeker.lactation) + str(seeker.breast_type) + " breasts. Her eyes are " + str(seeker.eye_color) + ". She has " + str(seeker.hair_color) + " hair that is " + str(seeker.hair_type) + ". " + str(seeker.posture) + ". " + str(seeker.armor_description) 



func apply_equipment(seeker):
	match seeker.weapon:
		"Twin Daggers": #agility, will power weapon, low threat
			seeker.skill_objects.append(Skill.new("Multi Slash",true, true, false, false, 3 + seeker.strength * 0.2 + seeker.agility * 0.2, 0, 0,[""], "Slashing", false, false, 2, "Swing with both daggers hitting twice, uses equal amount agility and strength for damage.", 5 + seeker.intelligence * 0.3, 1.5, 0, false, false, false, false, false )) #double attack, agility for damage
			seeker.skills.append("Multi Slash")
			seeker.skills.append("Lightfoot") #lower threat based on agility
			seeker.skill_objects.append(Skill.new("Vital Cut",true, true, false, false, 37 - seeker.threat, 0, 0,[""], "Slashing", false, false, 1, "A sneak attack that does damage based on how low your threat is.", 10 + seeker.intelligence * 0.3, 2.0, 0, false, false, false, false, false ))
			seeker.skills.append("Vital Cut") #add flat value minus threat, low hit (20 then - current threat)
			seeker.skill_objects.append(Skill.new("Distracting Strike",true, true, false, false, 2 + seeker.agility * 0.3 + seeker.strength * 0.2, 0, 0,[""], "Slashing", false, false, 1, "A light attack that allows you to quickly hide after the strike.", 5 + seeker.intelligence * 0.4, 1.5, 2, false, false, false, false, true ))
			seeker.skills.append("Distracting Strike") #damage based on intelligence)
		"Crossbow": #agility will power, average stats, extra skill
			seeker.skill_objects.append(Skill.new("Singular Shot",true, true, false, false, 6 + seeker.agility * 0.4 + seeker.will * 0.4, 0, 0,[""], "Piercing", true, false, 1, "A powerful bolt that takes a moment to fire again.", 1 + seeker.intelligence * 0.2, 1.5, 1, false, false, false, false, false ))
			seeker.skills.append("Singular Shot") #strong bolt, 1 turn cooldown
			seeker.skill_objects.append(Skill.new("Vault",false, false, false, true, 15, 0, 0,["Vault"], "", false, false, 1, "Increases agility and lowers threat.", 0, 0, 1, false, false, false, false, true ))
			seeker.skills.append("Vault") #lower threat increase speed and agility, reloads
			seeker.skill_objects.append(Skill.new("Napalm Bolt",true, true, false, false, 2 + seeker.agility * 0.2 + seeker.will * 0.3, 0, 0,["Burn"], "Fire", true, true, 1, "Shot a mortar like bolt that rains fire down onto the battlefield", 1 + seeker.intelligence, 1.2, 0, true, false, true, false, false))
			seeker.skills.append("Focus Impact") #increases dasmage by will, add to each Crossbow attack
			seeker.skills.append("Napalm Bolt") #aoe burn
			seeker.skill_objects.append(Skill.new("Inspire",false, false, true, false, 1 + seeker.will * 0.6, 0, 0,[""], "", true, false, 1, "Inspire allies using your will to regain stamina and keep pushing forward.", 1 + seeker.intelligence, 1.5, 1, false, false, false, false, false))
			seeker.skills.append("Inspire") #will heal once per battle
		"Flintlock": #intelligence agility weapon
			seeker.skills.append("Alchemic Blast") #basic attack, causes burn, poison or shock
			seeker.skills.append("Experimental Weaponry") # higher crit chance intelligenceh attack but chance of dealing self damage
			seeker.skills.append("Rejuvenating Syringe") #heal, intelligence based
			seeker.skills.append("Point Blank Shot") #agility attck, raises threat highly
		"Arcane Wand": #intelligence, basic speellcasting
			seeker.skills.append("Magic Missile") #guranteed hit 3 lots of damage
			seeker.skills.append("Runed Recovery") #lower lust and raise stamina slightly
			seeker.skills.append("Electric Arc") #hit multiple apply shock
			seeker.skills.append("Dispel Magic") #remove buffs or debuffs, interacts intelligenceh some curios
		"Animated Spellbook":
			seeker.skill_objects.append(Skill.new("Warding Words",false, false, true, false, 0, 0, 0,["Warded"], "Arcane", true, false, 1, "create a barrier that stops all harm, though the energy promotes desire.", 0, 0, 2, false, false, false, false, false ))
			seeker.skills.append("Warding Words") #add a barrier to stamina and lust
			seeker.skill_objects.append(Skill.new("Daemonic Advance",true, false, false, false, 1 + seeker.intelligence * 0.4 + seeker.will * 0.4, 0, 10,[""], "Arcane", true, false, 1, "Summon the power of abadon to flay your foes, harnessing their enegy has spicy consequences.", 1 + seeker.intelligence, 1.5, 0, false, false, false, false, false ))
			seeker.skills.append("Daemonic Advance") #attack opponent based on will and intelligence
			seeker.skill_objects.append(Skill.new("Echo of Ruin",true, false, false, false, 1 + seeker.lust * 0.4, 0, 10,[""], "Arcane", true, true, 1, "uses your lust as a conduit to burst outwards.", 1 + seeker.intelligence, 1.5, 1, false, true, false, false, false ))
			seeker.skills.append("Echo of ruin") #deal damage porpotinate to missing hp of enemy
			seeker.skills.append("Whispers of Venus") # gain lust or stamina at the end of the round
		"Broad Sword": #strength and will
			seeker.skills.append("Size up") #raise threat, barrier, strength
			seeker.skills.append("Excellence of Execution") #increasee crit chance and damage
			seeker.skills.append("Felling Swing") #if size up has been used increases damage
			seeker.skills.append("Stability") #heal self by will
		"Battle Axes": #strength, con weapon
			seeker.skills.append("Fury") #each attack skill causes an increasing strength and con modifier that is reset at the end of battle
			seeker.skills.append("Love of Battle") #taking damage heals 1-3 hp, needs to be from battle and an attack
			seeker.skills.append("Flurry of Iron") #double attack
			seeker.skills.append("Reckless Charge") #knock opponent prone
		"Great Club":
			seeker.skills.append("Clang!") #heavy attack
			seeker.skill_objects.append(Skill.new("Clang!",true, true, false, false, 10 + seeker.strength* 0.3 + seeker.durability * 0.1, 0, 0,[""], "Bludgeoning", false, false, 1, "Big weapon go bonk!.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
			seeker.skills.append("Colossal weapon") #High threat, low speed
		"Long Spear": #drawing a blank right now
			seeker.skills.append("Jab Thrust") #ignore barrier increase agaility
			seeker.skills.append("")
			seeker.skills.append("")
		"Disarmed":
			seeker.skills.append("Re-Equip") #chance to get weapon back
			seeker.skill_objects.append(Skill.new("Re-equip",false, false, false, true, 0, 0, 0,[""], "", false, false, 1, "grab your weapon.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
		"Unarmed":
			seeker.skills.append("Struggle") 
			seeker.skill_objects.append(Skill.new("Struggle",true, true, false, false, 1 + seeker.will * 0.1 + seeker.durability * 0.1, 0, 0,[""], "Bludgeoning", false, false, 1, "Fight the best you can.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
	match seeker.armor:
		"Naked":
			seeker.skills.append("Cover up") #gain barrier, gain threat, gain lust
			seeker.skill_objects.append(Skill.new("Cover up",false, false, false, false, 0, seeker.will * 0.5 , 10,[""], "", false, false, 1, "covering yourself in front of the enemy is somewhat tantilising.", 0, 0, 0, false, false, false, false, true ))
		"Graceful Robes":
			seeker.skills.append("Elegant Wrapping") #increases intelligence and will, lower threat. concentrate: next attack add intelligence to damage
			#seeker.skill_objects.append(Skill.new("Elegant wrapping",false, false, false, false, 0, 0, 0,[""], "", false, false, 1, "", 0, 0, 0, false, false, false, false, true ))
		"Bikini Armor":
			seeker.skills.append("Fit") #increase durability and strength by alot. Taunt: raises threat by alot gives half stamina as temp. once per battle
		"Dancer's Silk":
			seeker.skills.append("Entertainer") #Increases ddurability and agilkity. Encourage: remove a negative effect and give strength
		"Holy Garb":
			seeker.skills.append("Healing Service") #Increse will dramatically, lower threat. Service: increase lust but regain stamina
		"Fantasy Fullplate":
			seeker.skills.append("Mostly Protected") #Increase Strenght and durability raise threat, lower agility and intelligence. Protected: start combat intelligenceh 1 barrier
		"Skimpy Streetrat":
			seeker.skills.append("Hideaway") #increase agility and durability. Hideaway: lower threat to 0 for 1 round and gain brutality token
	for i in seeker.skills:
		match i:
			"Elegant Wrapping":
				seeker.intelligence += 5
				seeker.will += 5
				seeker.strength -= 5
				seeker.threat = 20
			"Fit":
				seeker.strength += 5
				seeker.durability += 5
				seeker.intelligence -= 5
				seeker.threat = 30
			"Hideaway":
				seeker.agility += 5
				seeker.will += 5
				seeker.durability -= 5
				seeker.threat = 10
			_:
				pass
	for i in seeker.skills:
		match i:
			"Lightfoot":
				seeker.threat -= 3
				seeker.agility += 5
			"Excellence of Execution":
				seeker.strength += 3
				seeker.intelligence += 3
			"Colossal weapon":
				seeker.threat += 6
				seeker.strength += 6
				seeker.agility -= 6
			_:
				pass
	print(seeker.skill_objects)


func _unequip_item_skills(seeker):
	print(seeker.skill_objects)
	for i in seeker.skills:
		match i:
			"Elegant Wrapping":
				seeker.intelligence -= 5
				seeker.will -= 5
				seeker.strength += 5
			"Fit":
				seeker.strength -= 5
				seeker.durability -= 5
				seeker.intelligence += 5
			"Hideaway":
				seeker.agility -= 5
				seeker.will -= 5
				seeker.durability += 5
			_:
				pass
	for i in seeker.skills:
		match i:
			"Lightfoot":
				seeker.threat += 3
				seeker.agility -= 5
			"Excellence of Execution":
				seeker.strength -= 3
				seeker.intelligence -= 3
			"Colossal weapon":
				seeker.threat -= 6
				seeker.strength -= 6
				seeker.agility += 3
			_:
				pass
	seeker.skill_objects.clear()
	match seeker.weapon:
		"Twin Daggers": #agility, will power weapon, low threat
			seeker.skills.erase("Multi Slash")
			seeker.skills.erase("Lightfoot") #lower threat based on agility
			seeker.skills.erase("Vital Cut") #add flat value minus threat, low hit (20 then - current threat)
			seeker.skills.erase("Distracting Strike") #damage based on intelligence)
		"Crossbow": #agility will power, average stats, extra skill
			seeker.skill_objects.erase(Skill.new("Singular Shot",true, true, false, false, 6 + seeker.agility * 0.4 + seeker.will * 0.4, 0, 0,[""], "Piercing", true, false, 1, "A powerful bolt that takes a moment to fire again.", 1 + seeker.intelligence * 0.2, 1.5, 1, false, false, false, false, false ))
			seeker.skills.erase("Singular Shot") #strong bolt, 1 turn cooldown
			seeker.skill_objects.erase(Skill.new("Vault",false, false, false, true, 15, 0, 0,["Vault"], "", false, false, 1, "Increases agility and lowers threat while removing cooldown.", 0, 0, 1, false, false, false, false, true ))
			seeker.skills.erase("Vault") #lower threat increase speed and agility, reloads
			seeker.skill_objects.erase(Skill.new("Napalm Bolt",true, false, false, false, 2 + seeker.agility * 0.2 + seeker.will * 0.3, 0, 0,["Burn"], "Fire", true, true, 1, "Shot a mortar like bolt that rains fire down onto the battlefield", 1 + seeker.intelligence, 1.2, 0, true, false, true, false, false))
			seeker.skills.erase("Focus Impact") #increases dasmage by will, add to each Crossbow attack
			seeker.skills.erase("Napalm Bolt") #aoe burn
			seeker.skill_objects.erase(Skill.new("Inspire",false, false, true, false, 1 + seeker.will * 0.6, 0, 0,[""], "", true, false, 1, "Inspire allies using your will to regain stamina and keep pushing forward.", 1 + seeker.intelligence, 1.5, 1, false, false, false, false, false))
			seeker.skills.erase("Inspire") #will heal once per battle
		"Flintlock": #intelligence agility weapon
			seeker.skills.erase("Alchemic Blast") #basic attack, causes burn, poison or shock
			seeker.skills.erase("Experimental Weaponry") # higher crit chance intelligenceh attack but chance of dealing self damage
			seeker.skills.erase("Rejuvenating Syringe") #heal, intelligence based
			seeker.skills.erase("Point Blank Shot") #agility attck, raises threat highly
		"Arcane Wand": #intelligence, basic speellcasting
			seeker.skills.erase("Magic Missile") #guranteed hit 3 lots of damage
			seeker.skills.erase("Runed Recovery") #lower lust and raise stamina slightly
			seeker.skills.erase("Electric Arc") #hit multiple apply shock
			seeker.skills.erase("Dispel Magic") #remove buffs or debuffs, interacts intelligenceh some curios
		"Animated Spellbook":
			seeker.skill_objects.erase(Skill.new("Warding Words",false, false, true, false, 0, 0, 0,["Warded"], "Arcane", true, false, 1, "create a barrier that stops all harm, though the energy promotes desire.", 0, 0, 2, false, false, false, false, false ))
			seeker.skills.erase("Warding Words") #add a barrier to stamina and lust
			seeker.skill_objects.erase(Skill.new("Daemonic Advance",true, false, false, false, 1 + seeker.intelligence * 0.4 + seeker.will * 0.4, 0, 10,[""], "Arcane", true, false, 1, "Summon the power of abadon to flay your foes, harnessing their enegy has spicy consequences.", 1 + seeker.intelligence, 1.5, 0, false, false, false, false, false ))
			seeker.skills.erase("Daemonic Advance") #attack opponent based on will and intelligence
			seeker.skill_objects.erase(Skill.new("Echo of Ruin",true, false, false, false, 1 + seeker.lust * 0.4, 0, 10,[""], "Arcane", true, true, 1, "uses your lust as a conduit to burst outwards.", 1 + seeker.intelligence, 1.5, 1, false, true, false, false, false ))
			seeker.skills.erase("Echo of ruin") #deal damage porpotinate to missing hp of enemy
			seeker.skills.erase("Whispers of Venus") 
		"Broad Sword": #strength and will
			seeker.skills.erase("Size up") #raise threat, barrier, strength
			seeker.skills.erase("Excellence of Execution") #increasee crit chance and damage
			seeker.skills.erase("Felling Swing") #if size up has been used increases damage
			seeker.skills.erase("Stability") #heal self by will
		"Battle Axes": #strength, con weapon
			seeker.skills.erase("Fury") #each attack skill causes an increasing strength and con modifier that is reset at the end of battle
			seeker.skills.erase("Love of Battle") #taking damage heals 1-3 hp, needs to be from battle and an attack
			seeker.skills.erase("Flurry of Iron") #double attack
			seeker.skills.erase("Reckless Charge") #knock opponent prone
		"Great Club":
			seeker.skills.erase("Clang!") #heavy attack
			seeker.skill_objects.erase(Skill.new("Clang!",true, true, false, false, 10 + seeker.strength* 0.3 + seeker.durability * 0.1, 0, 0,[""], "Bludgeoning", false, false, 1, "Big weapon go bonk!.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
			seeker.skills.erase("Colossal weapon") #High threat, low speed
		"Long Spear": #drawing a blank right now
			seeker.skills.erase("Jab Thrust") #ignore barrier increase agaility
			seeker.skills.erase("")
			seeker.skills.erase("")
		"Disarmed":
			seeker.skills.erase("Re-Equip") #chance to get weapon back
			seeker.skill_objects.erase(Skill.new("Re-equip",false, false, false, true, 0, 0, 0,[""], "", false, false, 1, "grab your weapon.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
		"Unarmed":
			var item_skills = ["Struggle"]
			seeker.skills.erase("Struggle") 
			seeker.skill_objects.erase(Skill.new("Struggle",true, true, false, false, 1 + seeker.will * 0.1 + seeker.durability * 0.1, 0, 0,[""], "Bludgeoning", false, false, 1, "Fight the best you can.", 5 + seeker.intelligence * 0.4, 2.0, 0, false, false, false, false, true ))
	match seeker.armor:
		"Naked":
			seeker.skills.erase("Cover up") #gain barrier, gain threat, gain lust
			seeker.skill_objects.erase(Skill.new("Cover up",false, false, false, false, 0, seeker.will * 0.5 , 10,[""], "", false, false, 1, "covering yourself in front of the enemy is somewhat tantilising.", 0, 0, 0, false, false, false, false, true )) #gain barrier, gain threat, gain lust
		"Graceful Robes":
			seeker.skills.erase("Elegant Wrapping") #increases intelligence and will, lower threat. concentrate: next attack add intelligence to damage
		"Bikini Armor":
			seeker.skills.erase("Fit") #increase durability and strength by alot. Taunt: raises threat by alot gives half stamina as temp. once per battle
		"Dancer's Silk":
			seeker.skills.erase("Entertainer") #Increases ddurability and agilkity. Encourage: remove a negative effect and give strength
		"Holy Garb":
			seeker.skills.erase("Healing Service") #Increse will dramatically, lower threat. Service: increase lust but regain stamina
		"Fantasy Fullplate":
			seeker.skills.erase("Mostly Protected") #Increase Strenght and durability raise threat, lower agility and intelligence. Protected: start combat intelligenceh 1 barrier
		"Skimpy Streetrat":
			seeker.skills.erase("Hideaway")

func skill_erasing_func(seeker,item_list):
	for skill in item_list:
		seeker.skill_objects.erase(skill.title)
#
var scroll_container: ScrollContainer
var scroll_bar
var main_text: RichTextLabel
var button_container: VBoxContainer
var right_button_container: VBoxContainer
var skills_data

func _ready():
	var current_scene = get_tree().current_scene
	scroll_container = current_scene.get_node("ScrollContainer")
	scroll_bar = scroll_container.get_v_scroll_bar()
	main_text = current_scene.get_node("ScrollContainer/main_text")
	button_container = current_scene.get_node("ColorRect_base/VBoxContainer")
	right_button_container = current_scene.get_node("ColorRect_base/right_side_container")
	skills_data = "res://Scripts/Skills.gd"
	create_start_buttons()
	fill_recruits()

func fill_recruits():
	for_hire.clear()
	main_text.text = ""
	for i in recruitables:
		var seeker = Seeker.new()
		print(seeker.title)
		print(seeker.max_stamina)
		print(seeker.durability)
		print("-----------------------")
		apply_equipment(seeker)
		print(seeker.skill_objects)
		_non_equipment_stats_update(seeker)
		generate_description(seeker)
		#generate_description(seeker)
		_recalculate_seeker_stats(seeker)
		seeker.stamina = seeker.max_stamina
		for_hire.append(seeker)
	for starting_weaponss in range(3):
		var index = randi_range(0,starter_weapons.size() - 1)
		armory.append(starter_weapons[index])
	for starting_armorss in range(3):
		var index = randi_range(0,starter_armors.size() - 1)
		armor_armory.append(starter_armors[index])

func _non_equipment_stats_update(seeker):
	for quirk in quirks:
		match quirk:
			"Durable":
				seeker.durability += 3
			"Frail":
				seeker.durability -= 3
			"Strong":
				seeker.strength += 3
			"Weak":
				seeker.strength -= 3
			"Resolute":
				seeker.will += 3
			"Corruptable":
				seeker.will -= 3
			"Energetic":
				seeker.agility += 3
			"Lazy":
				seeker.strength -= 3
			#["Durable", "Frail", "Forceful", "Weak", "Aggressive", "Energetic", "Resolute", "Corruptable", "Bright", "Dim","Bimbo", "Enlightened", "Talented", "Overconfident"]
	

func _on_recruit_show_pressed():
	clear_seeker_buttons()
	if for_hire.size() == 0:
		main_text.text = "There is no one available to employ"
	else:
		for seeker in for_hire:
			main_text.text += "------------------------"
			main_text.text += "\nSeeker Name: " + seeker.title
			main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
			main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
			main_text.text += "\n"
			main_text.text += "\nStrength: " + str(seeker.strength)
			main_text.text += "\nAgility: " + str(seeker.agility)
			main_text.text += "\nDurability: " + str(seeker.durability)
			main_text.text += "\nIntelligence: " + str(seeker.intelligence)
			main_text.text += "\nWill: " + str(seeker.will)
			main_text.text += "\nThreat: " + str(seeker.threat)
			main_text.text += "\n"
			main_text.text += "\nSkills: " + str(seeker.skills)
			main_text.text += "\nQuirks: " + str(seeker.quirks)
			main_text.text += "\nFetishes: " + str(seeker.fetishes)
			main_text.text += "\n"
			main_text.text += "\nDescription: " + seeker.description
			main_text.text += "\n"
			main_text.text += "\nWeapon: " + seeker.weapon
			main_text.text += "\nArmor: " + seeker.armor
			main_text.text += "\n------------------------\n\n"
			var recruit_button = Button.new()
			recruit_button.text = seeker.title
			button_container.add_child(recruit_button)
			recruit_button.pressed.connect(Callable(self, "_on_seeker_recruited").bind(seeker))
			left_buttons.append(recruit_button)
		var base_menu = Button.new()
		base_menu.text = "Back"
		button_container.add_child(base_menu)
		base_menu.pressed.connect(Callable(self, "create_start_buttons"))
		left_buttons.append(base_menu)


	
func _on_seeker_recruited(seeker):
	roster.append(seeker)
	for_hire.erase(seeker)
	main_text.text = seeker.title + " has been moved to her room.\n\n"
	_on_recruit_show_pressed()
	
		

func _remove_from_departing(seeker):
	roster.append(seeker)
	departing.erase(seeker)
	clear_seeker_buttons()
	departing_screen()

func clear_seeker_buttons():
	for button in left_buttons:
		button_container.remove_child(button)
		button.queue_free()  # Free the button memory
	left_buttons.clear()  # Clear the list of buttons
	

func clear_enemy_buttons():
	for button in right_buttons:
		right_button_container.remove_child(button)
		button.queue_free()  # Free the button memory
	right_buttons.clear()  # Clear the list of buttons

#to do
#add the roster with buttons
# make it so duplicate quirks and names can't be plausible names not so much


func _to_roster():
	clear_seeker_buttons()
	main_text.text = ""
	for seeker in roster:
		var inspect_button = Button.new()
		inspect_button.text = seeker.title
		button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "_inspect").bind(seeker))
		left_buttons.append(inspect_button)
	var departing_button = Button.new()
	departing_button.text = "Departing"
	button_container.add_child(departing_button)
	departing_button.pressed.connect(Callable(self, "departing_screen"))
	left_buttons.append(departing_button)
	var base_menu = Button.new()
	base_menu.text = "Back"
	button_container.add_child(base_menu)
	base_menu.pressed.connect(Callable(self, "create_start_buttons"))
	left_buttons.append(base_menu)
			

func _inspect(seeker):
	clear_seeker_buttons()
	var add_to_party_button = Button.new()
	add_to_party_button.text = "Add to departing"
	button_container.add_child(add_to_party_button)
	add_to_party_button.pressed.connect(Callable(self, "_add_to_party").bind(seeker))
	left_buttons.append(add_to_party_button)
	var unequip_weapon_button = Button.new()
	unequip_weapon_button.text = "Strip Weapon"
	if seeker.weapon == "Unarmed":
		unequip_weapon_button.text = "Give Weapon"
	button_container.add_child(unequip_weapon_button)
	unequip_weapon_button.pressed.connect(Callable(self, "_on_unequip_weapon_pressed").bind(seeker,unequip_weapon_button))
	left_buttons.append(unequip_weapon_button)
	var unequip_armor_button = Button.new()
	unequip_armor_button.text = "Strip Armor"
	if seeker.armor == "Naked":
		unequip_weapon_button.text = "Give Armor"
	button_container.add_child(unequip_armor_button)
	unequip_armor_button.pressed.connect(Callable(self, "_on_unequip_armor_pressed").bind(seeker,unequip_armor_button))
	left_buttons.append(unequip_armor_button)
	var back_button = Button.new()
	back_button.text = "Backs"
	button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "_to_roster"))
	left_buttons.append(back_button)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"

func _inspect_departing(seeker):
	clear_seeker_buttons()
	var remove_from_departing_button = Button.new()
	remove_from_departing_button.text = "Remove from Departing"
	button_container.add_child(remove_from_departing_button)
	remove_from_departing_button.pressed.connect(Callable(self, "_remove_from_departing").bind(seeker))
	left_buttons.append(remove_from_departing_button)
	var unequip_weapon_button = Button.new()
	unequip_weapon_button.text = "Strip Weapon"
	if seeker.weapon == "Unarmed":
		unequip_weapon_button.text = "Give Weapon"
	button_container.add_child(unequip_weapon_button)
	unequip_weapon_button.pressed.connect(Callable(self, "_on_unequip_weapon_pressed_depart").bind(seeker,unequip_weapon_button))
	left_buttons.append(unequip_weapon_button)
	var unequip_armor_button = Button.new()
	unequip_armor_button.text = "Strip Armor"
	if seeker.armor == "Naked":
		unequip_weapon_button.text = "Give Armor"
	button_container.add_child(unequip_armor_button)
	unequip_armor_button.pressed.connect(Callable(self, "_on_unequip_armor_pressed_depart").bind(seeker,unequip_armor_button))
	left_buttons.append(unequip_armor_button)
	var back_button = Button.new()
	back_button.text = "Backs"
	button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "departing_screen"))
	left_buttons.append(back_button)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"

func _on_unequip_armor_pressed(seeker, unequip_armor_button): #have the women have logic on whether or not they will allow themselves to be striped
	var overconfident = false
	for i in seeker.quirks:
		match i:
			"Overconfident":
				overconfident = true
	if seeker.armor == "Naked":
		clear_seeker_buttons()
		for armor in armor_armory:
			var armor_button = Button.new()
			armor_button.text = armor
			button_container.add_child(armor_button)
			armor_button.pressed.connect(Callable(self, "equip_armor").bind(seeker,armor))
			left_buttons.append(armor_button)
		var back_button = Button.new()
		back_button.text = "Back"
		button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "_inspect").bind(seeker))
		left_buttons.append(back_button)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		unequip_armor_button.hide()
		#back to roster function should help here
		#do inventory here
	elif overconfident == true and seeker.armor != "Naked":
		unequip_armor_button.text = "Give Armor"
		armor_armory.append(seeker.armor)
		_unequip_item_skills(seeker)
		seeker.armor = "Naked"
		apply_equipment(seeker)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		#have corruption diffent text and a couple randoms, for example high corruption: You're right i don't need a weapon to finish my enemies, or with fetishes maso: Hmm i'll be a walking training dummy~
		main_text.text += "\n\n" + str(seeker.title) + ": Don't forget to pick your jaw off the floor once you're done staring at my perfect body."
	else:
		main_text.text += "\n\n" + str(seeker.title) + ": No, you just want to watch me strip, perv."
		unequip_armor_button.hide()


func _on_unequip_weapon_pressed(seeker, unequip_weapon_button):
	var overconfident = false
	for i in seeker.quirks:
		match i:
			"Overconfident":
				overconfident = true
	if seeker.weapon == "Unarmed":
		clear_seeker_buttons()
		for weapun in armory:
			var weapon_button = Button.new()
			weapon_button.text = weapun
			button_container.add_child(weapon_button)
			weapon_button.pressed.connect(Callable(self, "equip_weapon").bind(seeker,weapun))
			left_buttons.append(weapon_button)
		var back_button = Button.new()
		back_button.text = "Back"
		button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "_inspect").bind(seeker))
		left_buttons.append(back_button)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		unequip_weapon_button.hide()
		#back to roster function should help here
		#do inventory here
	elif overconfident == true and seeker.weapon != "Unarmed":
		unequip_weapon_button.text = "Give Weapon"
		armory.append(seeker.weapon)
		_unequip_item_skills(seeker)
		seeker.weapon = "Unarmed"
		apply_equipment(seeker)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		#have corruption diffent text and a couple randoms, for example high corruption: You're right i don't need a weapon to finish my enemies, or with fetishes maso: Hmm i'll be a walking training dummy~
		main_text.text += "\n\n" + str(seeker.title) + ": Sure take it, I don't even need a weapon to be victorious."
	else:
		main_text.text += "\n\n" + str(seeker.title) + ": There is no way I'm letting you take my weapon."
		unequip_weapon_button.hide()
	

func equip_weapon(seeker, weapun):
	_unequip_item_skills(seeker)
	seeker.weapon = weapun
	armory.erase(weapun)
	apply_equipment(seeker)
	update_description(seeker)
	_recalculate_seeker_stats(seeker)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"
	clear_seeker_buttons()
	for i in roster:
		var inspect_button = Button.new()
		inspect_button.text = i.title
		button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "_inspect").bind(i))
		left_buttons.append(inspect_button)
	

func equip_armor(seeker, armori):
	_unequip_item_skills(seeker)
	seeker.armor = armori
	armor_armory.erase(armori)
	apply_equipment(seeker)
	update_description(seeker)
	_recalculate_seeker_stats(seeker)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"
	clear_seeker_buttons()
	for i in roster:
		var inspect_button = Button.new()
		inspect_button.text = i.title
		button_container.add_child(inspect_button)
		inspect_button.pressed.connect(Callable(self, "_inspect").bind(i))
		left_buttons.append(inspect_button)

#use description to give advice on weapons along with looks
func _recalculate_seeker_stats(seeker):
	seeker.max_stamina = 10 + seeker.durability * 2
	if seeker.stamina >= seeker.max_stamina:
		seeker.stamina = seeker.max_stamina
	seeker.max_lust = 10 + seeker.will * 2
	if seeker.lust >= seeker.max_lust:
		seeker.lust = seeker.max_lust

func _add_to_party(seeker):
	if departing.size() <= 2:
		departing.append(seeker)
		roster.erase(seeker)
		clear_seeker_buttons()
		_to_roster()
	else: 
		main_text.text += "\n\nDeparting is full."

func departing_screen():
	clear_seeker_buttons()
	main_text.text = ""
	for seeker in departing:
		var seeker_inspect = Button.new()
		seeker_inspect.text = seeker.title
		button_container.add_child(seeker_inspect)
		seeker_inspect.pressed.connect(Callable(self, "_inspect_departing").bind(seeker))
		left_buttons.append(seeker_inspect)
		main_text.text += "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------\n\n"
	var back_button = Button.new()
	back_button.text = "Back"
	button_container.add_child(back_button)
	back_button.pressed.connect(Callable(self, "_to_roster"))
	left_buttons.append(back_button)
	var depart_button = Button.new()
	depart_button.text = "Depart"
	button_container.add_child(depart_button)
	depart_button.pressed.connect(Callable(self, "_depart"))
	left_buttons.append(depart_button)

func create_start_buttons():
	clear_seeker_buttons()
	main_text.text = ""
	var recruit_button = Button.new()
	recruit_button.text = "Recruit"
	button_container.add_child(recruit_button)
	recruit_button.pressed.connect(Callable(self, "_on_recruit_show_pressed"))
	left_buttons.append(recruit_button)
	var roster_button = Button.new()
	roster_button.text = "Roster"
	button_container.add_child(roster_button)
	roster_button.pressed.connect(Callable(self, "_to_roster"))
	left_buttons.append(roster_button)

func _depart():
	if departing.size() == 0:
		main_text.text += "There is currently no one departing."
	elif departing.size() <= 2:
		main_text.text = "I can have up to 3 seekers depart, is " + str(departing.size()) + " departing okay?"
		clear_seeker_buttons()
		var roster_button = Button.new()
		roster_button.text = "Add more"
		button_container.add_child(roster_button)
		roster_button.pressed.connect(Callable(self, "_to_roster"))
		left_buttons.append(roster_button)
		var proceed = Button.new()
		proceed.text = "Proceed"
		button_container.add_child(proceed)
		proceed.pressed.connect(Callable(self, "_pick_mission"))
		left_buttons.append(proceed)
	else: 
		main_text.text = "Should I depart with the following seekers?\n\n"
		clear_seeker_buttons()
		for seeker in departing:
			main_text.text += "------------------------"
			main_text.text += "\nSeeker Name: " + seeker.title
			main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
			main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
			main_text.text += "\n"
			main_text.text += "\nStrength: " + str(seeker.strength)
			main_text.text += "\nAgility: " + str(seeker.agility)
			main_text.text += "\nDurability: " + str(seeker.durability)
			main_text.text += "\nIntelligence: " + str(seeker.intelligence)
			main_text.text += "\nWill: " + str(seeker.will)
			main_text.text += "\nThreat: " + str(seeker.threat)
			main_text.text += "\n"
			main_text.text += "\nSkills: " + str(seeker.skills)
			main_text.text += "\nQuirks: " + str(seeker.quirks)
			main_text.text += "\nFetishes: " + str(seeker.fetishes)
			main_text.text += "\n"
			main_text.text += "\nDescription: " + seeker.description
			main_text.text += "\n"
			main_text.text += "\nWeapon: " + seeker.weapon
			main_text.text += "\nArmor: " + seeker.armor
			main_text.text += "\n------------------------\n\n"
		var roster_button = Button.new()
		roster_button.text = "Go_back"
		button_container.add_child(roster_button)
		roster_button.pressed.connect(Callable(self, "departing_screen"))
		left_buttons.append(roster_button)
		var proceed = Button.new()
		proceed.text = "Proceed"
		button_container.add_child(proceed)
		proceed.pressed.connect(Callable(self, "_pick_mission"))
		left_buttons.append(proceed)

func _pick_mission():
	clear_seeker_buttons()
	main_text.text = ""
	var proceed = Button.new()
	proceed.text = "Goblin Battle"
	button_container.add_child(proceed)
	proceed.pressed.connect(Callable(goblinbattle, "Goblin_battle"))
	left_buttons.append(proceed)


func _on_unequip_armor_pressed_depart(seeker, unequip_armor_button): #have the women have logic on whether or not they will allow themselves to be striped
	var overconfident = false
	for i in seeker.quirks:
		match i:
			"Overconfident":
				overconfident = true
	if seeker.armor == "Naked":
		clear_seeker_buttons()
		for armor in armor_armory:
			var armor_button = Button.new()
			armor_button.text = armor
			button_container.add_child(armor_button)
			armor_button.pressed.connect(Callable(self, "equip_armor_departing").bind(seeker,armor))
			left_buttons.append(armor_button)
		var back_button = Button.new()
		back_button.text = "Back"
		button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "_inspect_departing").bind(seeker))
		left_buttons.append(back_button)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		unequip_armor_button.hide()
		#back to roster function should help here
		#do inventory here
	elif overconfident == true and seeker.armor != "Naked":
		unequip_armor_button.text = "Give Armor"
		armor_armory.append(seeker.armor)
		_unequip_item_skills(seeker)
		seeker.armor = "Naked"
		apply_equipment(seeker)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		#have corruption diffent text and a couple randoms, for example high corruption: You're right i don't need a weapon to finish my enemies, or with fetishes maso: Hmm i'll be a walking training dummy~
		main_text.text += "\n\n" + str(seeker.title) + ": Don't forget to pick your jaw off the floor once you're done staring at my perfect body."
	else:
		main_text.text += "\n\n" + str(seeker.title) + ": No, you just want to watch me strip, perv."
		unequip_armor_button.hide()


func _on_unequip_weapon_pressed_depart(seeker, unequip_weapon_button):
	var overconfident = false
	for i in seeker.quirks:
		match i:
			"Overconfident":
				overconfident = true
	if seeker.weapon == "Unarmed":
		clear_seeker_buttons()
		for weapun in armory:
			var weapon_button = Button.new()
			weapon_button.text = weapun
			button_container.add_child(weapon_button)
			weapon_button.pressed.connect(Callable(self, "equip_weapon_departing").bind(seeker,weapun))
			left_buttons.append(weapon_button)
		var back_button = Button.new()
		back_button.text = "Back"
		button_container.add_child(back_button)
		back_button.pressed.connect(Callable(self, "_inspect_departing").bind(seeker))
		left_buttons.append(back_button)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		unequip_weapon_button.hide()
		#back to roster function should help here
		#do inventory here
	elif overconfident == true and seeker.weapon != "Unarmed":
		unequip_weapon_button.text = "Give Weapon"
		armory.append(seeker.weapon)
		_unequip_item_skills(seeker)
		seeker.weapon = "Unarmed"
		apply_equipment(seeker)
		_recalculate_seeker_stats(seeker)
		update_description(seeker)
		main_text.text = "------------------------"
		main_text.text += "\nSeeker Name: " + seeker.title
		main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
		main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
		main_text.text += "\n"
		main_text.text += "\nStrength: " + str(seeker.strength)
		main_text.text += "\nAgility: " + str(seeker.agility)
		main_text.text += "\nDurability: " + str(seeker.durability)
		main_text.text += "\nIntelligence: " + str(seeker.intelligence)
		main_text.text += "\nWill: " + str(seeker.will)
		main_text.text += "\nThreat: " + str(seeker.threat)
		main_text.text += "\n"
		main_text.text += "\nSkills: " + str(seeker.skills)
		main_text.text += "\nQuirks: " + str(seeker.quirks)
		main_text.text += "\nFetishes: " + str(seeker.fetishes)
		main_text.text += "\n"
		main_text.text += "\nDescription: " + seeker.description
		main_text.text += "\n"
		main_text.text += "\nWeapon: " + seeker.weapon
		main_text.text += "\nArmor: " + seeker.armor
		main_text.text += "\n------------------------"
		#have corruption diffent text and a couple randoms, for example high corruption: You're right i don't need a weapon to finish my enemies, or with fetishes maso: Hmm i'll be a walking training dummy~
		main_text.text += "\n\n" + str(seeker.title) + ": Sure take it, I don't even need a weapon to be victorious."
	else:
		main_text.text += "\n\n" + str(seeker.title) + ": There is no way I'm letting you take my weapon."
		unequip_weapon_button.hide()

func equip_weapon_departing(seeker, weapun):
	_unequip_item_skills(seeker)
	seeker.weapon = weapun
	armory.erase(weapun)
	apply_equipment(seeker)
	update_description(seeker)
	_recalculate_seeker_stats(seeker)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"
	clear_seeker_buttons()
	_inspect_departing(seeker)

func equip_armor_departing(seeker, armori):
	_unequip_item_skills(seeker)
	seeker.armor = armori
	armor_armory.erase(armori)
	apply_equipment(seeker)
	update_description(seeker)
	_recalculate_seeker_stats(seeker)
	main_text.text = "------------------------"
	main_text.text += "\nSeeker Name: " + seeker.title
	main_text.text += "\nHP: " + str(seeker.stamina) + "/" + str(seeker.max_stamina)
	main_text.text += "\nLust: " + str(seeker.lust) + "/" + str(seeker.max_lust)
	main_text.text += "\n"
	main_text.text += "\nStrength: " + str(seeker.strength)
	main_text.text += "\nAgility: " + str(seeker.agility)
	main_text.text += "\nDurability: " + str(seeker.durability)
	main_text.text += "\nIntelligence: " + str(seeker.intelligence)
	main_text.text += "\nWill: " + str(seeker.will)
	main_text.text += "\nThreat: " + str(seeker.threat)
	main_text.text += "\n"
	main_text.text += "\nSkills: " + str(seeker.skills)
	main_text.text += "\nQuirks: " + str(seeker.quirks)
	main_text.text += "\nFetishes: " + str(seeker.fetishes)
	main_text.text += "\n"
	main_text.text += "\nDescription: " + seeker.description
	main_text.text += "\n"
	main_text.text += "\nWeapon: " + seeker.weapon
	main_text.text += "\nArmor: " + seeker.armor
	main_text.text += "\n------------------------"
	clear_seeker_buttons()
	_inspect_departing(seeker)




































#dungeon stuff
#Pleasure paradise
#nodes: event, battle, trap, objective
# make battles unique, coffin seekers and seekers can parry and block each others attacks like a samurai showdown, while goblins hp swarm with their hp representing how many goblins are left. a single blowjob isn't effective but a gangbang sure is, and attacks slay multiple within reason, thralls are entirely focused on sex
# battle: dozens of goblins, Thralls, coffin seekers, subjugated, Carnival of carnage
# Goblins: Male, clubs and stones, can taunt with their dicks
# coffin seekers: 3-6, can be futanari, male or female, Any base weapons (increase with weapon tiers) (with weapons i'll be gaining maybe just unlock the weapon to equip to one hero. so i don't have like a list of 50 items in inventory)
# events: bar, volcano bar, goblin village, 
# traps: boulder, log swing, ambush, 
